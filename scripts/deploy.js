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
        "Nick Mandal", // Student name
        "https://i.imgur.com/WLzDQDp.jpeg", // Student image
        0, // Sleep
        0, // Nutrition
        0, // Activity
        
    );
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);
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