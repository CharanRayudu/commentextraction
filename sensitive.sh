#!/bin/bash

# Function to find and print email addresses
find_email_addresses() {
    while read -r line; do
        # Use a basic email regex pattern
        email_regex="[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}"
        while [[ $line =~ $email_regex ]]; do
            email="${BASH_REMATCH[0]}"
            if ! contains_element "$email" "${found_emails[@]}"; then
                echo "Found email: $email"
                found_emails+=("$email")
            fi
            line="${line/${BASH_REMATCH[0]}/}"
        done
    done < "$1"
}

# Function to find and print credit card numbers
find_credit_card_numbers() {
    while read -r line; do
        # Use the provided credit card regex pattern
        credit_card_regex="^(?:4[0-9]{12}(?:[0-9]{3})?|[25][1-7][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$"
        while [[ $line =~ $credit_card_regex ]]; do
            credit_card="${BASH_REMATCH[0]}"
            if ! contains_element "$credit_card" "${found_credit_cards[@]}"; then
                echo "Found credit card: $credit_card"
                found_credit_cards+=("$credit_card")
            fi
            line="${line/${BASH_REMATCH[0]}/}"
        done
    done < "$1"
}

# Function to find and print addresses
find_addresses() {
    while read -r line; do
        address_regex="^(\d{1,}) [a-zA-Z0-9\s]+(\,)? [a-zA-Z]+(\,)? [A-Z]{2} [0-9]{5,6}$"
        while [[ $line =~ $address_regex ]]; do
            address="${BASH_REMATCH[0]}"
            if ! contains_element "$address" "${found_addresses[@]}"; then
                echo "Found address: $address"
                found_addresses+=("$address")
            fi
            line="${line/${BASH_REMATCH[0]}/}"
        done
    done < "$1"
}

# Function to find and print IP addresses
find_ip_addresses() {
    while read -r line; do
        ip_regex="\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}\b"
        while [[ $line =~ $ip_regex ]]; do
            ip_address="${BASH_REMATCH[0]}"
            if ! contains_element "$ip_address" "${found_ip_addresses[@]}"; then
                echo "Found IP address: $ip_address"
                found_ip_addresses+=("$ip_address")
            fi
            line="${line/${BASH_REMATCH[0]}/}"
        done
    done < "$1"
}

# Function to find and print Social Security Numbers (SSNs)
find_ssns() {
    while read -r line; do
        ssn_regex="^(?!666|000|9\\d{2})\\d{3}-(?!00)\\d{2}-(?!0{4})\\d{4}$"
        while [[ $line =~ $ssn_regex ]]; do
            ssn="${BASH_REMATCH[0]}"
            if ! contains_element "$ssn" "${found_ssns[@]}"; then
                echo "Found SSN: $ssn"
                found_ssns+=("$ssn")
            fi
            line="${line/${BASH_REMATCH[0]}/}"
        done
    done < "$1"
}

# Function to check if an element exists in an array
contains_element() {
    local element="$1"
    shift
    local array=("$@")
    for item in "${array[@]}"; do
        if [[ "$item" == "$element" ]]; then
            return 0  # Element found in the array
        fi
    done
    return 1  # Element not found in the array
}

# Check if a file is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <file>"
    exit 1
fi

file="$1"

# Check if the file exists
if [ ! -f "$file" ]; then
    echo "File not found: $file"
    exit 1
fi

# Arrays to store found emails, credit card numbers, addresses, IP addresses, and SSNs
declare -a found_emails
declare -a found_credit_cards
declare -a found_addresses
declare -a found_ip_addresses
declare -a found_ssns

# Call the functions to find email addresses, credit card numbers, addresses, IP addresses, and SSNs
find_email_addresses "$file"
find_credit_card_numbers "$file"
find_addresses "$file"
find_ip_addresses "$file"
find_ssns "$file"
