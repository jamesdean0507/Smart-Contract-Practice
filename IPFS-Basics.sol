// SPDX-License-Identifier: Unliscenced
pragma solidity ^0.6.11;

contract IpfsStorage{
    mapping(address => string) public userFiles;
    
    function setFile(string memory file) external {
        userFiles[msg.sender] = file;
    }
    
    
    //initialize ipfs. 
    import IPFS from "ipfs";
    
    /// initIpfs() reate and connect an IPFS node used to read and upload files 
    async function initIpfs() {
        node = await IPFS.create();
        const version = await node.version();
        console.log("IPFS Node Version: ", version.version);
    }
    
    
    /// readCurrentUserFile() with the IPFS node, add a function to read the current file from the contract
    async function readCurrentUserFile() {
        const result = await ipfsContract.userFiles(
            defaultProvider.getSigner().getAddress()
        );
        return result;    
    }
    
    
    // upload a file to IPFS and store in contract
   
    /// setFile(): this function, after uploading a file, is used to store the IPFS hash inside the contract 
    async function setFile(hash) {
        const ipfsWithSigner = ipfsContract.connect(defaultProvider.getSigner());
        await ipfsWithSigner.setFile(hash);
        setIpfsHash(hash);
    }
    
    /// uploadFile(): this function will take a file and upload it to IPFS using our IPFS node
    async function uploadFile(file) {
        const files = [{ path: file.name + file.path, content: file }];
        for await (const result of node.add(files)) {
            await setFile(result.cid.string);
        }
    }
}