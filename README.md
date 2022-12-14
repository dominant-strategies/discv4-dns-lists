This repository is a downstream fork of [ethereum/discv4-dns-list](https://github.com/ethereum/discv4-dns-lists)
that includes DNS discovery information for Quai networks. The content of this repository and the associated
live DNS ENR records are updated by a scheduled Github Action configured [here](./.github/workflows/crawl.yml), and with
output visible under [the Actions tab](https://github.com/etclabscore/discv4-dns-lists/actions).

Source for the devp2p tool mentioned below which support Quai network filters
can be found at [dominant-strategies/go-quai](https://github.com/dominant-strategies/go-quai). 

Rather than _ethdisco.net_, the records held under this repository are published to the __blockd.info__ DNS name.

---

# discv4-dns-lists

This repository contains [EIP-1459][EIP-1459] node lists built by the go-ethereum devp2p
tool. These lists are published to quaidisco.xyz.

The nodes in the lists are found by crawling the Ethereum node discovery DHT. The entire
output of the crawl is available in the `all.json` file. We create lists for specific
blockchain networks by filtering `all.json` according to the ["eth" ENR entry value][eth-entry]
provided by each node.

If you want your node in the list, simply run your client and make sure it is reachable
through discovery. The crawler will pick it up and sort it into the right list
automatically.

[EIP-1459]: https://eips.ethereum.org/EIPS/eip-1459
[eth-entry]: https://github.com/ethereum/devp2p/blob/master/enr-entries/eth.md


# CI Secrets
CLOUDFLARE_API_TOKEN
QUAI_DNS_CLOUDFLARE_ZONEID
QUAI_DNS_DISCV4_KEY: The full content of the signing key file, eg. cat key.json | pbcopy.
QUAI_DNS_DISCV4_KEYPASS: The key's password.
PAT_REPO_USER