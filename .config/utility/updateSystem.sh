# Function to update the system
# This ensures the system is up-to-date before proceeding with installations
updateSystem() {
    echo "Updating system packages..."
    apt-get update && apt-get upgrade -y
    echo "System update finished."
}