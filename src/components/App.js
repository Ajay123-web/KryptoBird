import React from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from "../abis/Kryptobird.json";
import { useEffect, useState } from "react";
import {
  MDBCard,
  MDBCardBody,
  MDBCardTitle,
  MDBCardText,
  MDBCardImage,
  MDBBtn,
} from "mdb-react-ui-kit";

//import { shortenAddress } from "../utils/shortenAddress";
import "./App.css";

function App() {
  const [account, setAccount] = useState("");
  const [contract, setContract] = useState(null);
  const [totalSupply, setTotalSupply] = useState(0);
  const [kryptoBirdz, setArray] = useState([]);
  const [NFTLink, setNFTLink] = useState("");

  const loadWeb3 = async () => {
    try {
      const provider = await detectEthereumProvider();

      if (provider) {
        console.log("Ethereum wallet connected");
        window.web3 = new Web3(provider);
      } else {
        console.log("No ethereum wallet detected");
      }
    } catch (err) {
      console.log("Error in loading provider");
    }
  };

  const loadBlockchainData = async () => {
    const web3 = window.web3;
    const accounts = await web3.eth.getAccounts();
    setAccount(accounts[0]);
    const networkId = await web3.eth.net.getId();
    const networkData = KryptoBird.networks[networkId];
    if (networkData) {
      const abi = KryptoBird.abi;
      const address = networkData.address;
      const contract = new web3.eth.Contract(abi, address);
      setContract(contract);
      const totalSupply = await contract.methods.totalSupply().call();
      setTotalSupply(totalSupply);
      console.log(totalSupply);

      for (let i = 0; i < totalSupply; i++) {
        const kryptobird = await contract.methods.kryptoBirdz(i).call();
        setArray((kryptoBirdz) => [...kryptoBirdz, kryptobird]);
      }
    } else {
      window.alert("Smart Contract not deployed");
    }
  };

  const mint = async (kryptobird) => {
    try {
      await contract.methods
        .mint(kryptobird)
        .send({ from: account })
        .once("receipt", (receipt) => {
          setArray((kryptoBirdz) => [...kryptoBirdz, kryptobird]);
        });
    } catch {
      console.log("Something went wrong while minting");
    }
  };

  useEffect(() => {
    async function init_() {
      await loadWeb3();
      await loadBlockchainData();
    }

    init_();

    window.ethereum.on("accountsChanged", function () {
      init_();
    });
  }, []);

  return (
    <div className="container-filled">
      <nav
        className="navbar navbar-dark fixed-top 
                bg-dark flex-md-nowrap p-0 shadow"
      >
        <div
          className="navbar-brand col-sm-3 col-md-3 
                mr-0"
          style={{ color: "white" }}
        >
          Krypto Birdz NFTs (Non Fungible Tokens)
        </div>
        <ul className="navbar-nav px-3">
          <li
            className="nav-item text-nowrap
                d-none d-sm-none d-sm-block
                "
          >
            <small className="text-white">{account}</small>
          </li>
        </ul>
      </nav>

      <div className="container-fluid mt-1">
        <div className="row">
          <main role="main" className="col-lg-12 d-flex text-center">
            <div className="content mr-auto ml-auto" style={{ opacity: "0.8" }}>
              <h1 style={{ color: "black" }}>KryptoBirdz - NFT Marketplace</h1>
              <form
                onSubmit={(event) => {
                  event.preventDefault();
                  mint(NFTLink);
                }}
              >
                <input
                  type="text"
                  placeholder="Add a file location"
                  className="form-control mb-1"
                  onChange={(e) => setNFTLink(e.target.value)}
                />
                <input
                  style={{ margin: "6px" }}
                  type="submit"
                  className="btn btn-primary btn-black"
                  value="MINT"
                />
              </form>
            </div>
          </main>
        </div>
        <hr></hr>
        <div className="row textCenter">
          {kryptoBirdz.map((kryptoBird, key) => {
            return (
              <div>
                <div>
                  <MDBCard className="token img" style={{ maxWidth: "22rem" }}>
                    <MDBCardImage
                      src={kryptoBird}
                      position="top"
                      height="250rem"
                      style={{ marginRight: "4px" }}
                    />
                    <MDBCardBody>
                      <MDBCardTitle> KryptoBirdz-{key} </MDBCardTitle>
                      <MDBCardText>
                        {" "}
                        This is K-{key}. The KryptoBirdz are 20 uniquely
                        generated KBirdz from the cyberpunk cloud galaxy
                        Mystopia! There is only one of each bird and each bird
                        can be owned by a single person on the Ethereum
                        blockchain.{" "}
                      </MDBCardText>
                      <MDBBtn href={kryptoBird}>Download</MDBBtn>
                    </MDBCardBody>
                  </MDBCard>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
export default App;
