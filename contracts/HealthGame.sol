// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import 'base64-sol/base64.sol';

import "hardhat/console.sol";


contract HealthGame is ERC721 {
  struct CharacterAttributes {
      uint characterIndex;
      string name;
      string imageURI;
      uint energy;
      uint maxEnergy;
      uint sleep;
      uint nutrition;
      uint activity;
  }

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  CharacterAttributes[] defaultCharacters;

  // We create a mapping from the nft's tokenId => that NFTs attributes.
  mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

  struct Student {
    string name;
    string imageURI;
    uint sleep;
    uint nutrition;
    uint activity;
    }

  Student public student;


  // A mapping from an address => the NFTs tokenId. Gives me an ez way
  // to store the owner of the NFT and reference it later.
  mapping(address => uint256) public nftHolders;

  event CharacterNFTMinted(address sender, uint256 tokenId, uint256 characterIndex);
  event InstructionComplete(uint newStudentSleep, uint newStudentNutrition, uint newStudentActivity, uint newPlayerEnergy);

  constructor(
    string[] memory characterNames,
    string[] memory characterImageURIs,
    uint[] memory characterEnergy,
    uint[] memory characterSleep,
    uint[] memory characterNutrition,
    uint[] memory characterActivity,
    string memory studentName,
    string memory studentImageURI,
    uint sleep,
    uint nutrition,
    uint activity
  )
    ERC721("HealthGame", "HEYLTH")
  {
    student = Student({
        name: studentName,
        imageURI: studentImageURI,
        sleep: sleep,
        nutrition: nutrition,
        activity: activity
    });

    console.log("Done initializing student %s w/  img %s", student.name, student.imageURI);

    for(uint i = 0; i < characterNames.length; i += 1) {
      defaultCharacters.push(CharacterAttributes({
        characterIndex: i,
        name: characterNames[i],
        imageURI: characterImageURIs[i],
        energy: characterEnergy[i],
        maxEnergy: characterEnergy[i],
        sleep: characterSleep[i],
        nutrition: characterNutrition[i],
        activity: characterActivity[i]
      }));

      CharacterAttributes memory c = defaultCharacters[i];
      console.log("Done initializing %s w/ Energy %s, img %s", c.name, c.energy, c.imageURI);
    }
    _tokenIds.increment();
  }

  function mintCharacterNFT(uint _characterIndex) external {
    // Get current tokenId (starts at 1 since we incremented in the constructor).
    uint256 newItemId = _tokenIds.current();

    // The magical function! Assigns the tokenId to the caller's wallet address.
    _safeMint(msg.sender, newItemId);

    // We map the tokenId => their character attributes. More on this in
    // the lesson below.
    nftHolderAttributes[newItemId] = CharacterAttributes({
      characterIndex: _characterIndex,
      name: defaultCharacters[_characterIndex].name,
      imageURI: defaultCharacters[_characterIndex].imageURI,
      energy: defaultCharacters[_characterIndex].energy,
      maxEnergy: defaultCharacters[_characterIndex].maxEnergy,
      sleep: defaultCharacters[_characterIndex].sleep,
      nutrition: defaultCharacters[_characterIndex].nutrition,
      activity: defaultCharacters[_characterIndex].activity
    });

    console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);
    
    // Keep an easy way to see who owns what NFT.
    nftHolders[msg.sender] = newItemId;

    // Increment the tokenId for the next person that uses it.
    _tokenIds.increment();
    emit CharacterNFTMinted(msg.sender, newItemId, _characterIndex);

  }

  function tokenURI(uint256 _tokenId) public view override returns (string memory) {
    CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];

    string memory strEnergy = Strings.toString(charAttributes.energy);
    string memory strMaxEnergy = Strings.toString(charAttributes.maxEnergy);
    string memory strSleep = Strings.toString(charAttributes.sleep);
    string memory strNutrition = Strings.toString(charAttributes.nutrition);
    string memory strActivity = Strings.toString(charAttributes.activity);

    string memory json = Base64.encode(
        bytes(
        string(
            abi.encodePacked(
            '{"name": "',
            charAttributes.name,
            ' -- NFT #: ',
            Strings.toString(_tokenId),
            '", "description": "This is an NFT that lets people play in Health Game!", "image": "',
            charAttributes.imageURI,
            '", "attributes": [ { "trait_type": "Energy", "value": ',strEnergy,', "max_value":',strMaxEnergy,'}, { "trait_type": "Sleep Score", "value": ',
            strSleep,'}, { "trait_type": "Nutrition Score", "value": ',
            strNutrition,'}, { "trait_type": "Activity Score", "value": ',
            strActivity,'} ]}'
            )
        )
        )
    );

    string memory output = string(
        abi.encodePacked("data:application/json;base64,", json)
    );
    
    return output;
  }

  function instructStudent(uint technique_id) public {
    // Get the state of the player's NFT.
    uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
    CharacterAttributes storage player = nftHolderAttributes[nftTokenIdOfPlayer];
    console.log("\nPlayer w/ character %s about to instruct. Has %s energy and %s sleep", player.name, player.energy, player.sleep);
    console.log("Student %s has %s sleep, %s nutrition", student.name, student.sleep, student.nutrition);

    // Make sure the player has more than 0 HP.
    require (
        player.energy > 0,
        "Error: character must have energy to instruct student."
    );

    // TODO Make sure the student has what it needs.

    // TODO Allow player to instruct student.
    if (technique_id == 0) {
      // 8 hours of sleep
      student.sleep = student.sleep + 5;
    } else if (technique_id == 1) {
      // Consistent sleep schedule
      student.sleep = student.sleep + 7;
    } else if (technique_id == 2) {
      // Mindful substance consumption
      student.sleep = student.sleep + 3;
    } else if (technique_id == 3) {
      // Zone II
      student.activity = student.activity + 4;
    } else if (technique_id == 4) {
      // Levers of nutrition
      student.nutrition = student.nutrition + 10;
    } else if (technique_id == 5) {
      // Dynamic Neuromuscular Stabilization
      student.activity = student.activity + 5;
    } else if (technique_id == 6) {
      // Full-body strength
      student.activity = student.activity + 9;
    } else if (technique_id == 7) {
      // 10k steps
      student.activity = student.activity + 2;
    } else if (technique_id == 8) {
      // Meal logging
      student.nutrition = student.nutrition + 6;
    } else if (technique_id == 9) {
      // Barre
      student.activity = student.activity + 3;
    } else if (technique_id == 10) {
      // Pilates
      student.activity = student.activity + 3;
    } else if (technique_id == 11) {
      // Tabata
      student.activity = student.activity + 3;
      student.sleep = student.sleep - 7;
    } 

    // Allow boss to drain player energy.
    if (player.energy < 1) {
        player.energy = 0;
    } else {
        player.energy = player.energy - 1;
    }

    emit InstructionComplete(student.sleep, student.nutrition, student.activity, player.energy);
  }

  function checkIfUserHasNFT() public view returns (CharacterAttributes memory) {
    // Get the tokenId of the user's character NFT
    uint256 userNftTokenId = nftHolders[msg.sender];
    // If the user has a tokenId in the map, return their character.
    if (userNftTokenId > 0) {
        return nftHolderAttributes[userNftTokenId];
    }
    // Else, return an empty character.
    else {
        CharacterAttributes memory emptyStruct;
        return emptyStruct;
    }
  }

  function getAllDefaultCharacters() public view returns (CharacterAttributes[] memory) {
    return defaultCharacters;
  }

  function getStudent() public view returns (Student memory) {
    return student;
  }

}