package env

import (
	"fmt"
	"os"
)

func GetAWSParamStoreKeyName(name string) string {
	return fmt.Sprintf("/%s/%s/%s", GetAppName(), GetAppEnv(), name)
}

func GetAppName() string {
	return os.Getenv("app_name")
}

func GetAppEnv() string {
	return os.Getenv("app_env")
}

func GetAppVersion() string {
	return os.Getenv("app_version")
}
