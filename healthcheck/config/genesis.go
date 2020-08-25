package config

import (
    "encoding/json"
    "io/ioutil"
    "os"
    "time"
)

type genesis struct {
    GenesisBlockCreationTime time.Time `json:"systemStart"`
    SlotsPerEpoch            uint64    `json:"epochLength"`
    SlotDurationInS          uint64    `json:"slotLength"`
}

func ParseGenesis(genesisFilePath string) (*genesis, error) {
    genesisFile, err := os.Open(genesisFilePath)
    if err != nil {
        return nil, err
    }
    genesisData, err := ioutil.ReadAll(genesisFile)
    if err != nil {
        return nil, err
    }
    var genesis genesis
    err = json.Unmarshal(genesisData, &genesis)
    if err != nil {
        return nil, nil
    }
    return &genesis, nil
}
