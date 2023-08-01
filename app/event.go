package main

type GameEvent struct {
	Version            string `json:"version"`
	LeaderboardAddress string `json:"leaderboard_address"`
	Serial             string `json:"serial"`
	Model              string `json:"model"`
	AutomaticUpdates   bool   `json:"automatic_updates"`
}
