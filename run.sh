#!/bin/bash

# MOBA Game Dashboard - Quick Start Script
# CPS510 DBMS Project

echo "=========================================="
echo "MOBA Game Dashboard - Starting..."
echo "=========================================="
echo ""

# Activate virtual environment
if [ -d "env" ]; then
    echo "✓ Activating virtual environment..."
    source env/bin/activate
else
    echo "✗ Virtual environment not found!"
    echo "  Please run: python3 -m venv env"
    exit 1
fi

# Check if Flask is installed
python -c "import flask" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "✗ Flask not installed!"
    echo "  Please run: pip install -r requirements.txt"
    exit 1
fi

echo "✓ Flask installed"
echo ""
echo "Starting Flask application..."
echo "Access the dashboard at: http://127.0.0.1:5000/"
echo ""
echo "Press Ctrl+C to stop the server"
echo "=========================================="
echo ""

# Run the Flask app
python app.py

