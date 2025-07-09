#!/bin/bash
pm2 stop nextjs-app || true
pm2 delete nextjs-app || true