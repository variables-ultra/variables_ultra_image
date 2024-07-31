#!/usr/bin/env just --justfile

set windows-shell := ["cmd.exe", "/c"]

tunnel_version := `cat tunnel/version`

start_elk:
    docker compose -f ./elk/docker-compose.yaml -p elk --env-file elk/elk.env up -d

start_runner:
    docker compose -f ./runner/test-runner.yaml -p test_runner --env-file runner/app/test.env up -d
    docker exec -it proxy zsh

stop_runner:
    docker compose -f ./runner/test-runner.yaml -p test_runner --env-file runner/app/test.env down

restart_runner: stop_runner start_runner

update_runner service:
    docker compose -f ./runner/test-runner.yaml -p test_runner --env-file runner/app/test.env \
        up -d --no-deps --build --force-recreate {{service}}

build_tunnel:
    docker build -t tunnel -f tunnel/Dockerfile .

push_tunnel $CR_PAT:
    echo $CR_PAT | docker login ghcr.io -u bppleman --password-stdin
    docker tag tunnel ghcr.io/bppleman/tunnel
    docker push ghcr.io/bppleman/tunnel
    docker tag tunnel ghcr.io/bppleman/tunnel:{{tunnel_version}}
    docker push ghcr.io/bppleman/tunnel:{{tunnel_version}}

deploy_tunnel $CR_PAT:
    # https://learn.microsoft.com/zh-cn/cli/azure/container?view=azure-cli-latest#az-container-create
    az container create \
        --resource-group BppleMan \
        --name tunnel \
        --location southcentralus \
        --image ghcr.io/bppleman/tunnel \
        --registry-login-server ghcr.io \
        --registry-username bppleman \
        --registry-password $CR_PAT \
        --cpu 1 \
        --memory 1 \
        --os-type Linux \
        --ports 22 80 443 5432 \
        --protocol TCP \
        --restart-policy OnFailure \
        --dns-name-label tunnel
#        --vnet 0e62efb3-bbaa-46da-a16e-5f6fa0ccf3d4 \
#        --subnet /subscriptions/5e4cb25b-c8bc-4e14-8171-3aa8605b4cf4/resourceGroups/VariablesUltra/providers/Microsoft.Network/virtualNetworks/database-vnet/subnets/container

test_tunnel: build_tunnel
    docker run -it --rm \
        -p 2222:22 \
        -p 80:80 \
        -p 443:443 \
        -p 5432:5432 \
        --name test-tunnel \
        tunnel
