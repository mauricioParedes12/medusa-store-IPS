#!/bin/sh
cd apps/backend
npx medusa db:migrate
npx medusa develop