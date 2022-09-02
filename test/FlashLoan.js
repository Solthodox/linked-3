const {ethers} = require("hardhat")
const {expect} = require("chai")
const { Transaction } = require("ethereumjs-tx")


const toEther = (n) => {
    return ethers.utils.parseUnits(n.toString() , "ether")

}

describe("FlashLoan" , ()=>{
    let flashLoan , receiver , token
    let deployer
    
    beforeEach(async()=>{
        accounts = await ethers.getSigners()
        deployer = accounts[0]

        // Setup contract instnaces
        const Token = await ethers.getContractFactory("WEth")
        token = await Token.deploy()
        const FlashLoan = await ethers.getContractFactory("LendingPool")
        flashLoan = await FlashLoan.deploy(token.address)
        const FlashLoanReceiver = await ethers.getContractFactory("Borrower")
        receiver = await FlashLoanReceiver.deploy(flashLoan.address)
        const tx =await token.approve(flashLoan.address , toEther(1000))
        await tx.wait()
        
        

    })
    describe("Deployment" , ()=>{
        it("Deployed correctly" , async()=>{
            const tx = await flashLoan.addAsset(token.address ,toEther(500) , 50 , 0);
            await tx.wait()

            const balance = await token.balanceOf(flashLoan.address)
            expect(balance).to.equal(toEther(500))
        })

    })

    describe("Borrowing Funds" , () => {
        it("Should borrow funds from the pool", async function(){
            let amount = toEther(50)
            const tx = await receiver.executeFlashLoan(amount);
            await tx.wait()
            expect(tx).to.emit(FlashLoanReceiver , loanReceived)
                .withArgs(token.address , amount)
        })

    })
})