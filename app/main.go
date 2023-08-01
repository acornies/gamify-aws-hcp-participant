package main

import (
	"bytes"
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/hashicorp/vault/api"
)

func handler(ctx context.Context, sqsEvent events.SQSEvent) error {

	// Check for required env vars env vars
	secretFile := os.Getenv("VAULT_SECRET_FILE_DB")
	if secretFile == "" {
		return errors.New("no VAULT_SECRET_FILE_DB environment variable, exiting")
	}

	dbURL := os.Getenv("DATABASE_ADDR")
	if dbURL == "" {
		return errors.New("no DATABASE_ADDR environment variable, exiting")
	}

	dbName := os.Getenv("DATABASE_NAME")
	if dbName == "" {
		return errors.New("no DATABASE_NAME environment variable, exiting")
	}

	// Read the secret from the file before processing the event
	secretRaw, err := ioutil.ReadFile(secretFile)
	if err != nil {
		return fmt.Errorf("error reading file: %w", err)
	}

	// Decode the JSON into a map[string]interface{}
	var secret api.Secret
	b := bytes.NewBuffer(secretRaw)
	dec := json.NewDecoder(b)
	// While decoding JSON values, interpret the integer values as `json.Number`s
	// instead of `float64`.
	dec.UseNumber()

	if err := dec.Decode(&secret); err != nil {
		return err
	}

	// Connect to the database and insert the registration
	connStr := fmt.Sprintf("postgres://%s:%s@%s/%s?sslmode=disable", secret.Data["username"], secret.Data["password"], dbURL, dbName)
	_, err = sql.Open("postgres", connStr)
	if err != nil {
		return err
	}

	fmt.Printf("Successfully connected to the database")

	// We don't need to do anything with the DB connection
	// The exercise is securing the connection with Vault
	// move on to determining points at this stage

	for _, message := range sqsEvent.Records {
		fmt.Printf("The message %s for event source %s = %s \n", message.MessageId, message.EventSource, message.Body)

		// Unmarshal the JSON into a GameEvent struct
		var event GameEvent
		if err := json.Unmarshal([]byte(message.Body), &event); err != nil {
			return err
		}

		// if the participants have made it this far, they get x points
		fmt.Printf("Send payload to leaderboard: %s", event.LeaderboardAddress)
		// TODO finish the function
	}

	return nil
}

func main() {
	lambda.Start(handler)
}
