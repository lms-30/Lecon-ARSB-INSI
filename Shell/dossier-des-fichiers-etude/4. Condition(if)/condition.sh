#!/bin/bash

read -p "Entrez un nombre : " nb

if [ $nb -gt 10 ]; then
	echo "Nombre supérieur à 10"
elif [ $nb -eq 10 ]; then
	echo "Nombre est égale à 10"
else
	echo "Nombre inférieur à 10"
fi
