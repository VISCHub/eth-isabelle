open Yojson.Basic
open VmTestParser

type blockHeader =
  (* XXX: If the hashes are just 256-bit values, they can also be encoded as big_int *)
  { bhBloom : string
  ; bhCoinbase : Big_int.big_int
  ; bhDifficulty : Big_int.big_int
  ; bhExtraData : string
  ; bhGasLimit : Big_int.big_int
  ; bhGasUsed : Big_int.big_int
  ; bhHash : string
  ; bhMixHash : string
  ; bhNonce : Big_int.big_int
  ; bhNumber : Big_int.big_int
  ; bhParentHash : string
  ; bhReceiptTrie : string
  ; bhStateRoot : string
  ; bhTimestamp : Big_int.big_int
  ; bhTransactionsTrie : string
  ; bhUncleHash : string
  }

let parse_block_header (j : json) : blockHeader =
  try
  Util.(
    { bhBloom = to_string (member "bloom" j)
    ; bhCoinbase = parse_address_from_field "coinbase" j
    ; bhDifficulty = parse_address_from_field "difficulty" j
    ; bhExtraData = to_string (member "extraData" j)
    ; bhGasLimit = parse_address_from_field "gasLimit" j
    ; bhGasUsed = parse_address_from_field "gasUsed" j
    ; bhHash = to_string (member "hash" j)
    ; bhMixHash = to_string (member "mixHash" j)
    ; bhNonce = parse_address_from_field "nonce" j
    ; bhNumber = parse_address_from_field "number" j
    ; bhParentHash = to_string (member "parentHash" j)
    ; bhReceiptTrie = to_string (member "receiptTrie" j)
    ; bhStateRoot = to_string (member "stateRoot" j)
    ; bhTimestamp = parse_address_from_field "timestamp" j
    ; bhTransactionsTrie = to_string (member "transactionsTrie" j)
    ; bhUncleHash = to_string (member "uncleHash" j)
  })
  with e ->
       let () = Printf.eprintf "error in parse_block_header\n%!" in
       raise e


let format_block_header (bh : blockHeader) : Easy_format.t =
  try
  let open Easy_format in
  let lst : t list =
    [ Label ((Atom ("bloom", atom), label), Atom (bh.bhBloom, atom))
    ; Label ((Atom ("coinbase", atom), label), Atom (Big_int.string_of_big_int bh.bhCoinbase, atom))
    ; Label ((Atom ("difficulty", atom), label), Atom (Big_int.string_of_big_int bh.bhDifficulty, atom))
    ; Label ((Atom ("extraData", atom), label), Atom (bh.bhExtraData, atom))
    ; Label ((Atom ("gasLimit", atom), label), Atom (Big_int.string_of_big_int bh.bhGasLimit, atom))
    ; Label ((Atom ("gasUsed", atom), label), Atom (Big_int.string_of_big_int bh.bhGasUsed, atom))
    ; Label ((Atom ("hash", atom), label), Atom (bh.bhHash, atom))
    ; Label ((Atom ("mixHash", atom), label), Atom (bh.bhMixHash, atom))
    ; Label ((Atom ("nonce", atom), label), Atom (Big_int.string_of_big_int bh.bhNonce, atom))
    ; Label ((Atom ("number", atom), label), Atom (Big_int.string_of_big_int bh.bhNumber, atom))
    ; Label ((Atom ("parentHash", atom), label), Atom (bh.bhParentHash, atom))
    ; Label ((Atom ("receiptTrie", atom), label), Atom (bh.bhReceiptTrie, atom))
    ; Label ((Atom ("stateRoot", atom), label), Atom (bh.bhStateRoot, atom))
    ; Label ((Atom ("timestamp", atom), label), Atom (Big_int.string_of_big_int bh.bhTimestamp, atom))
    ] in
  List (("{", ",", "}", list), lst)
  with e ->
    let () = Printf.eprintf "error in format_block_header\n%!" in
    raise e

type transaction =
  { transactionData : string
  ; transactionGasLimit : Big_int.big_int
  ; transactionGasPrice : Big_int.big_int
  ; transactionNonce : Big_int.big_int
  ; transactionR : Big_int.big_int
  ; transactionS : Big_int.big_int
  ; transactionTo : Big_int.big_int option
  ; transactionV : Big_int.big_int
  ; transactionValue : Big_int.big_int
  }

let parse_transaction (j : json) : transaction =
  let open Util in
  { transactionData = to_string (member "data" j)
  ; transactionGasLimit = parse_address_from_field "gasLimit" j
  ; transactionGasPrice = parse_address_from_field "gasPrice" j
  ; transactionNonce = parse_address_from_field "nonce" j
  ; transactionR = parse_address_from_field "r" j
  ; transactionS = parse_address_from_field "s" j
  ; transactionTo =
      if (to_string (member "data" j) = "" || to_string (member "data" j) = "0x")
      then
        None (* XXX: this needs to be tested *)
      else
        Some (parse_address_from_field "to" j)
  ; transactionV = parse_address_from_field "v" j
  ; transactionValue = parse_address_from_field "value" j
  }

let format_transaction (t : transaction) : Easy_format.t =
  let open Easy_format in
  let lst : t list =
    [ Label ((Atom ("data", atom), label), Atom (t.transactionData, atom))
    ; Label ((Atom ("gasLimit", atom), label), Atom (Big_int.string_of_big_int t.transactionGasLimit, atom))
    ; Label ((Atom ("gasPrice", atom), label), Atom (Big_int.string_of_big_int t.transactionGasPrice, atom))
    ; Label ((Atom ("nonce", atom), label), Atom (Big_int.string_of_big_int t.transactionNonce, atom))
    ; Label ((Atom ("r", atom), label), Atom (Big_int.string_of_big_int t.transactionR, atom))
    ; Label ((Atom ("s", atom), label), Atom (Big_int.string_of_big_int t.transactionS, atom))
    ; Label ((Atom ("to", atom), label), Atom (
                                             (match t.transactionTo with
                                             | Some addr -> Big_int.string_of_big_int addr
                                             | None -> ""), atom))
    ; Label ((Atom ("v", atom), label), Atom (Big_int.string_of_big_int t.transactionV, atom))
    ; Label ((Atom ("value", atom), label), Atom (Big_int.string_of_big_int t.transactionValue, atom))
    ] in
  List (("{", ",", "}", list), lst)

let gas_price_as_rlp_obj = failwith "gas_price_as_rlp_obj"
let gas_limit_as_rlp_obj = failwith "gas_limit_as_rlp_obj"
let to_as_rlp_obj = failwith "to_as_rlp_obj"
let value_as_rlp_obj = failwith "value_as_rlp_obj"
let w_as_rlp_obj = failwith "w_as_rlp_obj"
let r_as_rlp_obj = failwith "r_as_rlp_obj"
let s_as_rlp_obj = failwith "s_as_rlp_obj"

let rlp_of_transaction (t : transaction) =
  Conv.byte_list_of_rope
    (Rlp.encode
       (RlpList
          [ Rlp.rlpBigInt t.transactionNonce
          ; gas_price_as_rlp_obj t
          ; gas_limit_as_rlp_obj t
          ; to_as_rlp_obj t
          ; value_as_rlp_obj t
          ; w_as_rlp_obj t
          ; r_as_rlp_obj t
          ; s_as_rlp_obj t]))

(* rlp_of_transaction returns the keccak hash of the rlp encoding of a transaction *)
let hash_of_transaction (t : transaction) : Secp256k1.buffer =
  let rlp : Keccak.byte list = rlp_of_transaction t in
  let hash : Keccak.byte list = Keccak.keccak' rlp in
  failwith "hash_of_transaction: how to convert a byte list into a buffer?"

let sender_of_transaction (t : transaction) : Evm.address =
  let ctx = Secp256k1.(Context.create [Verify]) in
  let msg = hash_of_transaction t in (* wow, it looks like I need to implement RLP! *)
  let sign = failwith "sign" in
  let recovered = Secp256k1.RecoverableSign.recover ctx sign msg in
  failwith "sender_of_transaction"

type block =
  { blockHeader : blockHeader
  ; blockNumber : Big_int.big_int option (* This field is just informational *)
  ; blockRLP : string
  ; blockTransactions : transaction list
  ; blockUncleHeaders : blockHeader list (* ?? *)
  }

exception UnsupportedEncoding

let print_and_forward_exception str x =
  try x with e ->
    let () = Printf.eprintf str in
    raise e

let parse_block (j : json) : block =
  if Yojson.Basic.(Util.member "blockHeader" j =  `Null) then
    raise UnsupportedEncoding;
  let open Util in
  { blockHeader =
      print_and_forward_exception
        "error in parsing blockHeader\n%!"
        (parse_block_header (member "blockHeader" j))
  ; blockNumber =
      (try Some (parse_big_int_from_field "blocknumber" j)
       with _ -> None)
  ; blockRLP = to_string (member "rlp" j)
  ; blockTransactions =
      print_and_forward_exception
        "error in parsing transactions\n%!"
        (List.map parse_transaction (TestUtil.to_list_allow_null (member "transactions" j)))
  ; blockUncleHeaders =
      print_and_forward_exception
        "error in parsing uncle headers\n%!"
        (List.map parse_block_header (TestUtil.to_list_allow_null (member "uncleHeaders" j)))
  }

let format_block (b : block) : Easy_format.t =
  let open Easy_format in
  let lst : t list =
    [ Label ((Atom ("blockHeader", atom), label), format_block_header b.blockHeader)
    ; Label ((Atom ("blockNumber", atom), label), Atom ((match b.blockNumber with Some bn -> Big_int.string_of_big_int bn | None -> "(null)"), atom))
    ; Label ((Atom ("rlp", atom), label), Atom (b.blockRLP, atom))
    ; Label ((Atom ("transactions", atom), label),
             List (("[", ",", "]", list), List.map format_transaction b.blockTransactions))
    ; Label ((Atom ("uncleHeaders", atom), label),
             List (("[", ",", "]", list), List.map format_block_header b.blockUncleHeaders))
    ] in
  List (("{", ",", "}", list), lst)

type testCase =
  { bcCaseBlocks : block list
  ; bcCaseGenesisBlockHeader : blockHeader
  ; bcCaseGenesisRLP : string
  ; bcCaseLastBlockhash : string
  ; bcCasePostState : (string * VmTestParser.account_state) list
  ; bcCasePreState : (string * VmTestParser.account_state) list
  }

let parse_blocks (js : json list) : block list =
  List.map parse_block js

let parse_test_case (name : string) (j : json) : testCase =
  let () = Printf.printf "...... parsing test case %s\n" name in
  let () = if Yojson.Basic.(Util.member "genesisRLP" j = `Null) then
             raise UnsupportedEncoding in
  let open Util in
  { bcCaseBlocks =
      (let block_list = to_list (member "blocks" j) in
       print_and_forward_exception
         "error while parsing blocks\n%!"
         (parse_blocks block_list))
  ; bcCaseGenesisBlockHeader =
      print_and_forward_exception
        "error while parsing genesis block header\n%!"
        (parse_block_header (member "genesisBlockHeader" j))
  ; bcCaseGenesisRLP =
      print_and_forward_exception
        "error while parsing genesis RLP\n%!"
        (to_string (member "genesisRLP" j))
  ; bcCaseLastBlockhash =
      print_and_forward_exception
        "error while parsing last block hash\n%!"
        (to_string (member "lastblockhash" j))
  ; bcCasePostState =
      print_and_forward_exception
        "error while parsing post state\n%!"
        (VmTestParser.parse_states (to_assoc (member "postState" j)))
  ; bcCasePreState =
      print_and_forward_exception
        "error while parsing pre state\n%!"
        (VmTestParser.parse_states (to_assoc (member "pre" j)))
  }

let parse_test_file (js : json) =
  List.map
    (fun (name, case) -> (name, parse_test_case name case))
    (Util.to_assoc js)

let format_blocks (bs : block list) =
  Easy_format.(List (("[", ",", "]", list), List.map format_block bs))

let format_test_case (t : testCase) : Easy_format.t =
  let open Easy_format in
  let lst =
    [ Label ((Atom ("blocks", atom), label), format_blocks t.bcCaseBlocks)
    ; Label ((Atom ("geneisBlockHeader", atom), label), format_block_header t.bcCaseGenesisBlockHeader)
    ; Label ((Atom ("genesisRLP", atom), label), Atom (t.bcCaseGenesisRLP, atom))
    ; Label ((Atom ("lastblockhash", atom), label), Atom (t.bcCaseLastBlockhash, atom))
    ; Label ((Atom ("postState", atom), label), Atom ("(printing not implemented)", atom))
    ; Label ((Atom ("pre", atom), label), Atom ("(printing not implemented)", atom))
    ] in
  List (("{", ",", "}", list), lst)


(* TODO: very similar to StateTestLib.construct_block_info.  refactor *)
let block_info_of (b : block) : Evm.block_info =
  let bh = b.blockHeader in
  Evm.(
    { block_blockhash = (fun _ -> failwith "blockhash not implemented")
    ; block_coinbase = Conv.word160_of_big_int bh.bhCoinbase
    ; block_timestamp = Conv.word256_of_big_int bh.bhTimestamp
    ; block_number = Conv.word256_of_big_int bh.bhNumber
    ; block_difficulty = Conv.word256_of_big_int bh.bhDifficulty
    ; block_gaslimit = Conv.word256_of_big_int bh.bhGasLimit
    }
  )
