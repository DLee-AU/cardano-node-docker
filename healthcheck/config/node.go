package config

import (
    "encoding/json"
    "io/ioutil"
    "os"
)

type node struct {
    Prometheus []interface{} `json:"hasPrometheus"`
}

func ParseNodeConfig(configFilePath string) (*node, error) {
    configFile, err := os.Open(configFilePath)
    configFileData, err := ioutil.ReadAll(configFile)
    if err != nil {
        return nil, err
    }
    var nodeConfig node
    err = json.Unmarshal(configFileData, &nodeConfig)
    if err != nil {
        return nil, err
    }
    return &nodeConfig, nil
}
