#!/bin/bash

for node in {1..4}; do
	docker kill R$node
done
