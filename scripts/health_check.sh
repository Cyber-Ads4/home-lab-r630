#!/bin/bash

echo "================================"
echo "   R630 Server Health Check"
echo "   $(date)"
echo "================================"
echo ""

echo "--- CPU Load ---"
uptime

echo ""
echo "--- Memory Usage ---"
free -h

echo ""
echo "--- Disk Usage ---"
df -h /

echo ""
echo "--- Temperature ---"
sensors 2>/dev/null || echo "Install lm-sensors for temperature"

echo ""
echo "--- Network ---"
ip addr show eno3 | grep "inet "

echo ""
echo "--- Uptime ---"
uptime -p

echo ""
echo "--- Top 5 Processes ---"
ps aux --sort=-%cpu | head -6

echo ""
echo "================================"
echo "   Health Check Complete"
echo "================================"
