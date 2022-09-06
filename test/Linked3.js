const {ethers} = require("hardhat")
const {expect} = require("chai")
const { Transaction } = require("ethereumjs-tx")


const toEther = (n) => {
    return ethers.utils.parseUnits(n.toString() , "ether")

}

describe("Linked3" , ()=>{
    let main , token
    let deployer
    
    beforeEach(async()=>{
        console.log("Deploying...")
        accounts = await ethers.getSigners()
        deployer = accounts[0]

        // Setup contract instances
        const Token = await ethers.getContractFactory("Linked3")
        token = await Token.deploy()
        const Main = await ethers.getContractFactory("main")
        main = await Main.deploy(token.address)
        
        console.log("Deployed!")
        const approval = await token.approve(main.address , toEther(1000))
        await approval.wait()
        

    })
 
    it("Registers user correctly" , async()=>{
        
        const register = await main.registerUser("hjdhkdf" ,ethers.utils.formatBytes32String(""))
        await register.wait()
        
    })
    
    it("Registers Companies correctly" , async()=>{
        const referral = await main.getReferral(deployer.address)
        const register = await main.registerCompany("hjdhkdf" , referral)
        await register.wait()
        
    })


   

})