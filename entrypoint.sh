#!/bin/ash -xe

get_from_event() {
  jq -r "$1" "${GITHUB_EVENT_PATH}"
}

if [ -z "${INPUT_SUCCESS}" ]; then
  echo "Missing input success"
  exit 1
fi
INPUT_STATUS=$(echo "$INPUT_SUCCESS" | tr '[:upper:]' '[:lower:]')

if jq --exit-status '.inputs.ROLLOUT_DEPLOYMENT_ID' "$GITHUB_EVENT_PATH" >/dev/null; then
  MONOPOLIS_URL="https://api.monopolis.cloud/v1/rollout/finish/$(get_from_event '.repository.name')/$(get_from_event '.inputs.ROLLOUT_DEPLOYMENT_ID')/${INPUT_SUCCESS}"

  curl --fail -X POST "${MONOPOLIS_URL}" -H "Authorization: Bearer ${MONOPOLIS_API_KEY}"
fi
