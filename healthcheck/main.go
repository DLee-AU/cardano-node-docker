package main

import (
    "flag"
    "fmt"
    ctime "github.com/godano/cardano-lib/time"
    "healthcheck/config"
    "healthcheck/health"
    "math/big"
    "os"
    "time"
)

func getTimeSettings() ctime.TimeSettings {
    genesisFilePath := os.Getenv("CN_CHECK_GENESIS_FILE")
    if genesisFilePath == "" {
        panic("You have to specify the path to genesis file with the environment variable 'CN_CHECK_GENESIS_FILE'.")
    }
    genesis, err := config.ParseGenesis(genesisFilePath)
    if err != nil {
        panic(fmt.Sprintf("The genesis at '%s' cannot be parsed: %s\n",
            genesisFilePath, err.Error()))
    }
    return ctime.TimeSettings{
        GenesisBlockDateTime: genesis.GenesisBlockCreationTime,
        SlotsPerEpoch:        new(big.Int).SetUint64(genesis.SlotsPerEpoch),
        SlotDuration:         time.Duration(genesis.SlotDurationInS) * time.Second,
    }
}

func getPrometheusURL() string {
    configFilePath := os.Getenv("CN_CHECK_CONFIG_FILE")
    if configFilePath == "" {
        panic("You have to specify the path to nodeConfig file with the environment variable 'CN_CHECK_CONFIG_FILE'.")
    }
    nodeConfig, err := config.ParseNodeConfig(configFilePath)
    if err != nil {
        panic(fmt.Sprintf( "The node nodeConfig at '%s' cannot be parsed: %s\n", configFilePath,
            err.Error()))
    }
    return fmt.Sprintf("http://%v:%v/metrics", nodeConfig.Prometheus[0], nodeConfig.Prometheus[1])
}

func main() {
    check := os.Getenv("CN_CHECK")
    if check != "" && check != "false" {
        timeSettings := getTimeSettings()
        prometheusURL := getPrometheusURL()

        maxTimeSinceLastBlock := flag.Duration("max-time-since-last-block", 10*time.Minute,
            "threshold for duration between now and the creation date of the most recently received block")
        flag.Parse()

        health.Check(health.Config{
            PrometheusURL:         prometheusURL,
            TimeSettings:          timeSettings,
            MaxTimeSinceLastBlock: *maxTimeSinceLastBlock,
        })
    }
}
