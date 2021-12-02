const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('HealthGame');
    const gameContract = await gameContractFactory.deploy(
        ["Matthew Walker", "Peter Attia", "Will Tennyson", "Ally Love"],
        ["https://i.imgur.com/mmBH3Rf.jpeg",
        "https://i.imgur.com/hb3k67H.jpeg", 
        "https://i.imgur.com/ALrNi9W.png",
        "https://i.imgur.com/iUii00W.jpeg"],
        [10, 10, 10, 10], // energy
        [100, 90, 85, 80], // sleep
        [85, 100, 80, 90], // nutrition
        [80, 95, 100, 90], // activity

        // ["8 hours of sleep", "Zone II training", "Chest day", "Barre"],//, "DNS", "FTP test", "Tabata", "Morning sunlight exposure", "Breathwork", "ATG Split Squat", "Sauna"], // Move One
        // ["Consistent sleep schedule", "Nutrition levers", "10k steps", "Pilates"],//, "Deadlift"],//, "Power Zone training", "Barre", "Yoga Nidra", "Cold exposure", "Stretching", "Genome analysis"], // Move Two
        // ["Mindful caffeine and alcohol consumption", "DNS", "Meal logging", "Tabata"],
        "Nick Mandal", // Student name
        "https://i.imgur.com/WLzDQDp.jpeg", // Student image
        1, // Sleep
        2, // Nutrition
        3, // Activity
    );
        // 4 // Readiness
        // 4, // Stability
        // 5, // Strength
        // 6, // Aerobic Efficiency
        // 7, // Anaerobic Performance
        // 8, // Exogenous Factors
        // 9, // Emotional Health 
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);

    let txn;
    txn = await gameContract.mintCharacterNFT(2);
    await txn.wait();
    
    txn = await gameContract.instructStudent(1);
    await txn.wait();
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();