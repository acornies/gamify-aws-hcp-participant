package main

type GameEvent struct {
	Version            string `json:"version,omitempty"`
	LeaderboardAddress string `json:"leaderboard_address"`
	Serial             string `json:"serial,omitempty"`
	Model              string `json:"model,omitempty"`
	AutomaticUpdates   bool   `json:"automatic_updates,omitempty"`
}
