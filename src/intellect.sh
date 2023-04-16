#!/bin/bash

api="https://internal.intellect.co/api"
token=null
user_id=null
user_agent="okhttp/3.12.1"

function get_app_config() {
	curl --request GET \
		--url "$api/app/config" \
		--user-agent "$user_agent" \
		--header "accept: application/json"	\
		--header "content-type: application/json" \
		--header "authorization: $token"
}

function get_account_info() {
	curl --request GET \
		--url "$api/user/auth/me" \
		--user-agent "$user_agent" \
		--header "accept: application/json"	\
		--header "content-type: application/json" \
		--header "authorization: $token"
}

function login() {
	response=$(curl --request POST \
		--url "$api/user/auth/login" \
		--user-agent "$user_agent" \
		--header "accept: application/json"	\
		--header "content-type: application/json" \
		--data '{
			"email": "'$1'",
			"password": "'$2'"
		}')

	if [ $(jq -r ".success" <<< "$response") == "true" ]; then
		token=$(jq -r ".data.token" <<< "$response")
		user_id=$(jq -r ".data.id" <<< "$response")
	fi
	echo $response
}

function register() {
	curl --request POST \
		--url "$api/user/auth/register" \
		--user-agent "$user_agent" \
		--header "accept: application/json"	\
		--header "content-type: application/json" \
		--data '{
			"email": "'$1'",
			"password": "'$2'",
			"emailUpdates": "true",
			"name": "'$3'",
			"organisationData": {}
		}'
}

function get_goals() {
	curl --request GET \
		--url "$api/user/profile/goals/open?goalsType=$1" \
		--user-agent "$user_agent" \
		--header "accept: application/json"	\
		--header "content-type: application/json" \
		--header "authorization: $token"
}

function search_wisdom() {
	curl --request GET \
		--url "$api/wisdom/catalogues/search?query=$1" \
		--user-agent "$user_agent" \
		--header "accept: application/json"	\
		--header "content-type: application/json" \
		--header "authorization: $token"
}

function change_password() {
	curl --request PUT \
		--url "$api/user/auth/password" \
		--user-agent "$user_agent" \
		--header "accept: application/json"	\
		--header "content-type: application/json" \
		--header "authorization: $token" \
		--data '{
			"password": "'$1'"
		}'
}

function delete_account() {
	curl --request POST \
		--url "$api/user/auth/delete" \
		--user-agent "$user_agent" \
		--header "accept: application/json"	\
		--header "content-type: application/json" \
		--header "authorization: $token"
}


function get_widgets() {
	curl --request GET \
		--url "$api/wisdom/catalogues/home/widgets" \
		--user-agent "$user_agent" \
		--header "accept: application/json"	\
		--header "content-type: application/json" \
		--header "authorization: $token"
}

function forgot_password() {
	curl --request POST \
		--url "$api/user/auth/password/forgot/request" \
		--user-agent "$user_agent" \
		--header "accept: application/json"	\
		--header "content-type: application/json" \
		--header "authorization: $token" \
		--data '{
			"email": "'$1'"
		}'
}

function reset_password() {
	curl --request POST \
		--url "$api/user/auth/password/forgot/reset" \
		--user-agent "$user_agent" \
		--header "accept: application/json"	\
		--header "content-type: application/json" \
		--header "authorization: $token" \
		--data '{
			"email": "'$1'",
			"password": "'$2'",
			"code": "'$3'",
		}'
}
