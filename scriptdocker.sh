#!/bin/bash

echo "Este script requer a instalação do 'fzf' para funcionar corretamente."
echo "Deseja instalar o 'fzf' agora? (s/n)"
read -r resposta

installFzf() {
  echo "Iniciando a instalação do fzf..."

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt >/dev/null 2>&1; then
      sudo apt update && sudo apt install -y fzf
    elif command -v yum >/dev/null 2>&1; then
      sudo yum install -y fzf
    else
      echo "Gerenciador de pacotes não suportado. Instale manualmente o fzf."
      return 1
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v brew >/dev/null 2>&1; then
      brew install fzf
    else
      echo "Homebrew não encontrado. Instale manualmente o fzf."
      return 1
    fi
  else
    echo "Sistema operacional não suportado."
    return 1
  fi

  echo "Instalação concluída."
}

if [[ "$resposta" == "s" || "$resposta" == "S" ]]; then
  installFzf
fi

if ! command -v fzf >/dev/null 2>&1; then
  echo "O 'fzf' é necessário para executar este script. Por favor, instale-o e tente novamente."
  exit 1
fi

echo "############ Continuando o script... ############"

select_container() {
  CONTAINER_NAME=$(docker ps --format "{{.ID}} {{.Names}}" | fzf --height 20% --border --prompt="Selecione um contêiner para parar (ou ESC para pular): " --ansi)
  
  if [ -z "$CONTAINER_NAME" ]; then
    echo "Nenhum contêiner selecionado. Pulando esta etapa."
    return 1
  fi

  CONTAINER_NAME=$(echo "$CONTAINER_NAME" | awk '{print $1}')
}

stop_container() {
  if [ -z "$CONTAINER_NAME" ]; then
    select_container
  fi
  
  if [ -z "$CONTAINER_NAME" ]; then
    return 1
  fi

  echo "Deseja parar o contêiner selecionado ($CONTAINER_NAME)? (s/n)"
  read -r stop_response
  if [[ "$stop_response" == "s" || "$stop_response" == "S" ]]; then
    docker stop "$CONTAINER_NAME"
    echo "Contêiner $CONTAINER_NAME parado com sucesso."
  else
    echo "O contêiner $CONTAINER_NAME não será parado."
  fi
}

select_image() {
  echo "Buscando imagens Docker disponíveis..."
  IMAGE_NAME=$(docker images --format "{{.Repository}}:{{.Tag}} {{.ID}}" | fzf --height 20% --border --prompt="Selecione uma imagem para excluir (ou ESC para pular): " --ansi)

  if [ -z "$IMAGE_NAME" ]; then
    echo "Nenhuma imagem selecionada. Pulando esta etapa."
    return 1
  fi

  IMAGE_ID=$(echo "$IMAGE_NAME" | awk '{print $2}')
  delete_image "$IMAGE_ID"
}

delete_image() {
  local image_id=$1
  echo "Deseja excluir a imagem selecionada ($image_id)? (s/n)"
  read -r delete_response
  if [[ "$delete_response" == "s" || "$delete_response" == "S" ]]; then
    CONTAINERS_USING_IMAGE=$(docker ps -a --filter "ancestor=$image_id" --format "{{.ID}}")

    if [ -n "$CONTAINERS_USING_IMAGE" ]; then
      echo "A imagem está sendo usada pelos seguintes contêineres:"
      echo "$CONTAINERS_USING_IMAGE"
      echo "Deseja remover todos os contêineres associados à imagem ($image_id)? (s/n)"
      read -r remove_containers_response
      if [[ "$remove_containers_response" == "s" || "$remove_containers_response" == "S" ]]; then
        docker rm -f $CONTAINERS_USING_IMAGE
        echo "Contêineres removidos com sucesso."
      else
        echo "A imagem não será excluída porque ainda está em uso."
        return 1
      fi
    fi

    docker rmi "$image_id"
    echo "Imagem $image_id excluída com sucesso."
  else
    echo "A imagem $image_id não será excluída."
  fi
}

select_volume() {
  echo "Buscando volumes Docker disponíveis..."
  VOLUME_NAME=$(docker volume ls --format "{{.Name}}" | fzf --height 20% --border --prompt="Selecione um volume para excluir (ou ESC para pular): " --ansi)

  if [ -z "$VOLUME_NAME" ]; then
    echo "Nenhum volume selecionado. Pulando esta etapa."
    return 1
  fi

  delete_volume "$VOLUME_NAME"
}

delete_volume() {
  local volume_name=$1
  echo "Deseja excluir o volume selecionado ($volume_name)? (s/n)"
  read -r delete_response
  if [[ "$delete_response" == "s" || "$delete_response" == "S" ]]; then
    docker volume rm "$volume_name"
    echo "Volume $volume_name excluído com sucesso."
  else
    echo "O volume $volume_name não será excluído."
  fi
}

prune_system() {
  echo "Deseja executar o comando 'docker system prune' para remover recursos não utilizados? (s/n)"
  read -r prune_response
  if [[ "$prune_response" == "s" || "$prune_response" == "S" ]]; then
    sudo docker system prune -a --force --volumes
    echo "Sistema Docker limpo com sucesso!"
  else
    echo "O comando 'docker system prune' não foi executado."
  fi
}

### **Fluxo do script**
stop_container
select_image
select_volume
prune_system

echo "############ Processo concluído com sucesso! ############"

