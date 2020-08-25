package health

import (
    "bufio"
    "fmt"
    ctime "github.com/godano/cardano-lib/time"
    "io"
    "math/big"
    "net/http"
    "os"
    "strings"
    "time"
)

type Config struct {
    PrometheusURL         string
    TimeSettings          ctime.TimeSettings
    MaxTimeSinceLastBlock time.Duration
    MinPeerConnections    int
}

func log(msg string) {
    fmt.Printf("[%v][HEALTH CHECK] %s\n",
        time.Now().Format("2006-01-02T15:04:05-07:00"), msg)
}

func buildMap(r io.Reader) map[string]string {
    pMap := make(map[string]string)
    scanner := bufio.NewScanner(r)
    for scanner.Scan() {
        line := scanner.Text()
        lineArr := strings.Split(line, " ")
        if len(lineArr) == 2 {
            pMap[lineArr[0]] = lineArr[1]
        }
    }
    if err := scanner.Err(); err != nil {
        panic(fmt.Sprintf("Error reading response from Prometheus: '%s'.", scanner.Err().Error()))
    }
    return pMap
}

func checkMaxTimeSinceLastBlock(maxTimeSinceLastBlock time.Duration, pMap map[string]string,
    settings ctime.TimeSettings) {
    epochString, foundEpoch := pMap["cardano_node_ChainDB_metrics_epoch_int"]
    slotString, foundSlot := pMap["cardano_node_ChainDB_metrics_slotInEpoch_int"]
    if foundEpoch && foundSlot {
        epoch, validEpoch := new(big.Int).SetString(epochString, 10)
        slot, validSlot := new(big.Int).SetString(slotString, 10)
        if validEpoch && validSlot {
            slotDate, err := ctime.FullSlotDateFrom(epoch, slot, settings)
            if err != nil {
                panic(fmt.Sprintf("Epoch/Slot date does not match blockchain details: %s", err.Error()))
            }
            diff := time.Now().Sub(slotDate.GetEndDateTime())
            if time.Now().Sub(slotDate.GetEndDateTime()) > maxTimeSinceLastBlock {
                log(fmt.Sprintf("The last block has been received '%s' ago. It is over the threshold of %s.",
                    diff, maxTimeSinceLastBlock))
                os.Exit(1)
            }
        } else {
            panic("Epoch and slot in Prometheus endpoint are not valid integers.")
        }
    } else {
        panic("Could not find the correct information (epoch, slot) in the Prometheus endpoint.")
    }
}

// checks the node with the given config, and should the health fail, a non-zero code is returned.
func Check(config Config) {
    log("Starting to check health of node.")
    client := http.Client{
        Timeout: 5 * time.Second,
    }
    response, err := client.Get(config.PrometheusURL)
    if err != nil {
        panic(fmt.Sprintf("Not able to reach prometheus endpoint at '%s':%s.", config.PrometheusURL, err.Error()))
    }
    if 200 <= response.StatusCode && response.StatusCode < 300 {
        pMap := buildMap(response.Body)
        checkMaxTimeSinceLastBlock(config.MaxTimeSinceLastBlock, pMap, config.TimeSettings)
    } else {
        panic(fmt.Sprintf("Prometheus endpoint reported status code '%s'.", response.Status))
    }
}
