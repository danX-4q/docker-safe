#!/bin/bash

zpath=$(cd `dirname $0`; pwd)
cd $zpath > /dev/null

##############################

#usage:
#    $1: node name, which will be used to get node config 
#        at dir ../node/$1/eosio.conf(or eosio.env)

set -x

NM=${1-"a"}
N_C_DIR="../node/${NM}/"

cd $N_C_DIR
. eosio.env
cd -

##############################

CONTRACTS_DIR="${PWD}/../../../bankledger/safecode.contracts/build/contracts/"

##########

# https://github.com/EOSIO/eos/issues/7180
curl -X POST http://127.0.0.1:7770/v1/producer/schedule_protocol_feature_activations -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}' ||
{ echo "error when schedule_protocol_feature_activations"; exit 1; }
echo "sleep 4, wait preactive feature"
sleep 4

cd ${CONTRACTS_DIR}eosio.bios/
cleos-sc set contract eosio ${PWD} || { echo "error when set eosio.bios"; exit 1; }

cleos-sc push action eosio activate '["f0af56d2c5a48d60a4a5b5c903edfb7db3a736a94ed589d0b797df33ff9d3e1d"]' -p eosio # GET_SENDER
cleos-sc push action eosio activate '["2652f5f96006294109b3dd0bbde63693f55324af452b799ee137a81a905eed25"]' -p eosio # FORWARD_SETCODE
cleos-sc push action eosio activate '["8ba52fe7a3956c5cd3a656a3174b931d3bb2abb45578befc59f283ecd816a405"]' -p eosio # ONLY_BILL_FIRST_AUTHORIZER
cleos-sc push action eosio activate '["ad9e3d8f650687709fd68f4b90b41f7d825a365b02c23a636cef88ac2ac00c43"]' -p eosio # RESTRICT_ACTION_TO_SELF
cleos-sc push action eosio activate '["68dcaa34c0517d19666e6b33add67351d8c5f69e999ca1e37931bc410a297428"]' -p eosio # DISALLOW_EMPTY_PRODUCER_SCHEDULE
cleos-sc push action eosio activate '["e0fb64b1085cc5538970158d05a009c24e276fb94e1a0bf6a528b48fbc4ff526"]' -p eosio # FIX_LINKAUTH_RESTRICTION
cleos-sc push action eosio activate '["ef43112c6543b88db2283a2e077278c315ae2c84719a8b25f25cc88565fbea99"]' -p eosio # REPLACE_DEFERRED
cleos-sc push action eosio activate '["4a90c00d55454dc5b059055ca213579c6ea856967712a56017487886a4d4cc0f"]' -p eosio # NO_DUPLICATE_DEFERRED_ID
cleos-sc push action eosio activate '["1a99a59d87e06e09ec5b028a9cbb7749b4a5ad8819004365d02dc4379a8b7241"]' -p eosio # ONLY_LINK_TO_EXISTING_PERMISSION
cleos-sc push action eosio activate '["4e7bf348da00a945489b2a681749eb56f5de00b900014e137ddae39f48f69d67"]' -p eosio # RAM_RESTRICTIONS

##########
cleos-sc create account eosio eosio.token $K0_PUB
cd ${CONTRACTS_DIR}eosio.token/
cleos-sc set contract eosio.token ${PWD} || { echo "error when set eosio.token"; exit 1; }
cleos-sc push action eosio.token create '["eosio","4500000.00000000 SAFE"]' -p eosio.token@active

##########
cleos-sc create account eosio safe.oracle $K0_PUB
cd ${CONTRACTS_DIR}safe.oracle/
cleos-sc set contract safe.oracle ${PWD} || { echo "error when set safe.oracle"; exit 1; }

##########
cleos-sc create account eosio danx $K0_PUB
cleos-sc create account eosio danx1 $K0_PUB
cleos-sc create account eosio danx2 $K0_PUB

