# Linked 3

## General overview

This projects aims to create a decentralised blockchain landing job app with some added functionalities. The developers will have a reputation and experience and companies will be able to verify the projects this developers have built. The developers will be able to experience working in teams to build github repos doing collaborations with other users. Bad behaviour will be hardly punished reducing the trust level of the bad developer. Also , he will lose the collateral deposited to participate in the project. All the main functionalities will work using the platform`s own token. The companies will be able to post job offers and ask for certain requirements such as experience and trust level. The salary can be verified by the platform thorugh a salary contract. Also the app will have a referral code system
to encourage users to bring new people.

## Contracts

- Main.sol
- Collab.sol
- Salary.sol
- Linked3.sol

### Main

This contract has all the main functionalitties of the app such as :

- Post collab proposals and join them
- Post job offes and apply for them

For detailed documentation , see [Main.sol](https://github.com/XabierOterino/Linked3-JobLanding/blob/main/contracts/Main.sol)

### Collab

Contract to manage team work of different collaborations. All the contributors will need to deposit a collateral as a bail of their good intentions. All participants will have the option to raise or decrease other's reputations based on their experience working with them. Of course if most of contributors agree, a contributor can lose its collateral. See [Collab.sol](https://github.com/XabierOterino/Linked3-JobLanding/blob/main/contracts/Collab.sol) for more.

### Salary

If a company decides to hire a developer from the platform , the salary will be managed by a verified contract of the platform so the salary is public.
It can include many tokens as payment methods and in case of a missed payment , the employee will be able to put the collateral deposited by the company.
More details in [Salary.sol](https://github.com/XabierOterino/Linked3-JobLanding/blob/main/contracts/Salary.sol).


### Linked3

A mock token of the ERC-20 token used by the app.

## Initialization
```shell
npx hardhat run scripts/deploy.js
```
