// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Donor Registration Contract
/// @notice This contract allows users to register as donors and retrieve donor details.
/// @dev Uses a mapping to store donor details indexed by a unique ID.
contract DonorRegistration {
    /// @dev Structure to store donor details.
    struct Donor {
        uint256 id; // Unique identifier for the donor.
        bytes32 name; // Donor's name stored as bytes32 to save gas.
        bytes32 bloodType; // Donor's blood type stored as bytes32.
    }

    /// @dev Storage variable to maintain a mapping of donor ID to donor details.
    mapping(uint256 => Donor) private s_donor;

    /// @notice Event emitted when a new donor is registered.
    event DonorRegistered(uint256 id, bytes32 name, bytes32 bloodType);

    /// @dev Custom error to indicate that a donor with the given ID already exists.
    error AlreadyExists();

    /// @dev Custom error to indicate that a donor with the given ID does not exist.
    error NotExists();

    /// @notice Fetches the donor details by ID.
    /// @param _id The unique ID of the donor.
    /// @return Donor struct containing the donor's details.
    function getDonor(uint256 _id) external view returns (Donor memory) {
        // Check if the donor exists; if not, revert with NotExists error.
        if (s_donor[_id].id == 0) {
            revert NotExists();
        }

        return s_donor[_id];
    }

    /// @notice Registers a new donor.
    /// @dev Ensures the donor ID is unique before storing the data.
    /// @param _id The unique ID for the donor.
    /// @param _name The name of the donor (bytes32 format).
    /// @param _bloodType The blood type of the donor (bytes32 format).
    function registerDonor(uint256 _id, bytes32 _name, bytes32 _bloodType) external {
        // Check if the donor already exists; if so, revert with AlreadyExists error.
        if (s_donor[_id].id != 0) {
            revert AlreadyExists();
        }

        // Create a new donor struct and assign values.
        Donor memory singleDonor;
        singleDonor.id = _id;
        singleDonor.name = _name;
        singleDonor.bloodType = _bloodType;

        // Store the donor struct in the mapping.
        s_donor[_id] = singleDonor;

        // Emit an event to log the donor registration.
        emit DonorRegistered(_id, _name, _bloodType);
    }
}
