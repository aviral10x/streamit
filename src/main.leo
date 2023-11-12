// The 'hello' program.
program hello.aleo {
  mapping id_to_stream: field=> StreamInfo;
  mapping balances:field=>u32;
  record token {
    owner: address,
    amount: u32,
  }
  struct StreamInfo {
    receiver:address,
    sender: address,
    amount:u32,
    flow_rate:u32,
    block_height:u32,
    is_active: bool,
    
  }

  transition create_stream(receiver:address, amount:u32, flow_rate:u32)-> field{
    let unique_hash:field = BHP256::hash_to_field(receiver);
    let owner_hash:field = BHP256::hash_to_field(self.caller);
    return unique_hash then finalize(owner_hash,unique_hash,receiver, amount, flow_rate, self.caller);
  } 
  finalize create_stream(owner_hash:field,unique_hash:field,receiver:address, amount:u32, flow_rate:u32, owner:address){
    let current_amount_sender:u32 = Mapping::get_or_use(balances,owner_hash ,0u32);
    assert(current_amount_sender > amount);
    let about_strem:StreamInfo = StreamInfo {
      amount: amount,
      sender: owner,
      flow_rate: flow_rate,
      receiver:receiver,
      block_height: block.height,
      is_active:true
    };
    Mapping::set(id_to_stream, unique_hash, about_strem);
  }

  transition cancel_stream(unique_hash:field){
    return then finalize(unique_hash, self.caller);
  }
  finalize cancel_stream(unique_hash:field, invoker:address) {
    let temp_stream: StreamInfo = StreamInfo {
      receiver: aleo1q3y67syn3rnee2ku92p96nshv859vku584gpljasy7rx73z2lgxqp5c7hn,
      sender: aleo1q3y67syn3rnee2ku92p96nshv859vku584gpljasy7rx73z2lgxqp5c7hn,
      amount: 0u32,
      flow_rate: 0u32,
      block_height: 0u32,
      is_active: false
    };
    let current_stream: StreamInfo = Mapping::get_or_use(id_to_stream, unique_hash , temp_stream);
    assert_neq(current_stream.block_height,0u32);
    assert_eq(current_stream.is_active,true );
    
    if invoker == current_stream.receiver || invoker== current_stream.sender{
      let amount_streamed:u32 = check_balance(current_stream.block_height, block.height, current_stream.flow_rate);
      assert_neq(amount_streamed,0u32);
      assert_neq(amount_streamed, current_stream.amount);
      assert_neq(amount_streamed,current_stream.amount +1u32);
      let owner_hash: field = BHP256::hash_to_field(current_stream.sender);
      let receiver_hash:field = BHP256::hash_to_field(current_stream.receiver);
      let current_amount_sender:u32 = Mapping::get_or_use(balances,owner_hash ,0u32 );
      assert(current_amount_sender >= amount_streamed);
      Mapping::set(balances, owner_hash, current_amount_sender-amount_streamed);

      let current_amount_receiver:u32 = Mapping::get_or_use(balances, receiver_hash,0u32);
      Mapping::set(balances, receiver_hash, current_amount_receiver + amount_streamed);

      Mapping::remove(id_to_stream,unique_hash );
    
    } else {
      assert(false);
    }
    
  }
transition withdraw_from_stream(unique_hash:field){
  return then finalize(unique_hash,self.caller);
}
finalize withdraw_from_stream (unique_hash:field ,caller:address) { 
  let default_stream_info: StreamInfo = StreamInfo {
      // TODO: make it zero address or null address
      receiver: aleo1q3y67syn3rnee2ku92p96nshv859vku584gpljasy7rx73z2lgxqp5c7hn,
      sender: aleo1q3y67syn3rnee2ku92p96nshv859vku584gpljasy7rx73z2lgxqp5c7hn,
      amount: 0u32,
      flow_rate: 0u32,
      block_height: 0u32,
      is_active: false
  };
  let current_stream:StreamInfo = Mapping::get_or_use(id_to_stream,unique_hash ,default_stream_info);
  assert_eq(caller,current_stream.receiver);
  assert_eq(current_stream.is_active,true);

  let amount_streamed:u32 = check_balance(current_stream.block_height, block.height, current_stream.flow_rate);
  assert_neq(amount_streamed,0u32);
  assert_neq(amount_streamed,current_stream.amount +1u32);
  assert_eq(amount_streamed, current_stream.amount );
  let owner_hash: field = BHP256::hash_to_field(current_stream.sender);
  let receiver_hash:field = BHP256::hash_to_field(current_stream.receiver);
  let current_amount_sender:u32 = Mapping::get_or_use(balances,owner_hash ,0u32 );
  assert(current_amount_sender >= amount_streamed);
  Mapping::set(balances, owner_hash, current_amount_sender-amount_streamed);

  let current_amount_receiver:u32 = Mapping::get_or_use(balances, receiver_hash,0u32);
  Mapping::set(balances, receiver_hash, current_amount_receiver + amount_streamed);
  Mapping::remove(id_to_stream,unique_hash );
}
  
  transition main() -> token {
        let Token: token =  token{
            owner: self.caller,
            amount: 1000u32,
        };
        let owner_hash: field = BHP256::hash_to_field(self.caller);
        return Token then finalize(self.caller, owner_hash);
    }
    finalize main (owner:address, owner_hash:field) {
     let current_amount:u32 = Mapping::get_or_use(balances,owner_hash,0u32 );
     Mapping::set(balances, owner_hash, current_amount + 1000u32); 
    
    }
  inline check_balance (stream_created_time:u32, current_block_height:u32, flow_rate:u32) -> u32 {
  if current_block_height > stream_created_time {
    let time_elapsed:u32 = current_block_height - stream_created_time;
    let amount_already_streamed:u32 = time_elapsed * flow_rate;
    return amount_already_streamed;
  } else {
    return 0u32;  
    
  }
 }

}


