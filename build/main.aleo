program hello.aleo;

record token:
    owner as address.private;
    amount as u32.private;

struct StreamInfo:
    receiver as address;
    sender as address;
    amount as u32;
    flow_rate as u32;
    block_height as u32;
    is_active as boolean;


mapping id_to_stream:
	key as field.public;
	value as StreamInfo.public;


mapping balances:
	key as field.public;
	value as u32.public;

function create_stream:
    input r0 as address.private;
    input r1 as u32.private;
    input r2 as u32.private;
    hash.bhp256 r0 into r3 as field;
    hash.bhp256 self.caller into r4 as field;
    async create_stream r4 r3 r0 r1 r2 self.caller into r5;
    output r3 as field.private;
    output r5 as hello.aleo/create_stream.future;

finalize create_stream:
    input r0 as field.public;
    input r1 as field.public;
    input r2 as address.public;
    input r3 as u32.public;
    input r4 as u32.public;
    input r5 as address.public;
    get.or_use balances[r0] 0u32 into r6;
    gt r6 r3 into r7;
    assert.eq r7 true;
    cast r2 r5 r3 r4 block.height true into r8 as StreamInfo;
    set r8 into id_to_stream[r1];




function cancel_stream:
    input r0 as field.private;
    async cancel_stream r0 self.caller into r1;
    output r1 as hello.aleo/cancel_stream.future;

finalize cancel_stream:
    input r0 as field.public;
    input r1 as address.public;
    cast aleo1q3y67syn3rnee2ku92p96nshv859vku584gpljasy7rx73z2lgxqp5c7hn aleo1q3y67syn3rnee2ku92p96nshv859vku584gpljasy7rx73z2lgxqp5c7hn 0u32 0u32 0u32 false into r2 as StreamInfo;
    get.or_use id_to_stream[r0] r2 into r3;
    assert.neq r3.block_height 0u32;
    assert.eq r3.is_active true;
    is.eq r1 r3.receiver into r4;
    is.eq r1 r3.sender into r5;
    or r4 r5 into r6;
    gt block.height r3.block_height into r7;
    sub block.height r3.block_height into r8;
    mul r8 r3.flow_rate into r9;
    ternary r7 r9 0u32 into r10;
    not r6 into r11;
    is.neq r10 0u32 into r12;
    or r11 r12 into r13;
    assert.eq r13 true;
    not r6 into r14;
    is.neq r10 r3.amount into r15;
    or r14 r15 into r16;
    assert.eq r16 true;
    add r3.amount 1u32 into r17;
    not r6 into r18;
    is.neq r10 r17 into r19;
    or r18 r19 into r20;
    assert.eq r20 true;
    hash.bhp256 r3.sender into r21 as field;
    hash.bhp256 r3.receiver into r22 as field;
    get.or_use balances[r21] 0u32 into r23;
    gte r23 r10 into r24;
    not r6 into r25;
    or r25 r24 into r26;
    assert.eq r26 true;
    sub r23 r10 into r27;
    set r27 into balances[r21];
    get.or_use balances[r22] 0u32 into r28;
    add r28 r10 into r29;
    set r29 into balances[r22];
    remove id_to_stream[r0];
    not r6 into r30;
    not r30 into r31;
    or r31 false into r32;
    assert.eq r32 true;


function withdraw_from_stream:
    input r0 as field.private;
    async withdraw_from_stream r0 self.caller into r1;
    output r1 as hello.aleo/withdraw_from_stream.future;

finalize withdraw_from_stream:
    input r0 as field.public;
    input r1 as address.public;
    cast aleo1q3y67syn3rnee2ku92p96nshv859vku584gpljasy7rx73z2lgxqp5c7hn aleo1q3y67syn3rnee2ku92p96nshv859vku584gpljasy7rx73z2lgxqp5c7hn 0u32 0u32 0u32 false into r2 as StreamInfo;
    get.or_use id_to_stream[r0] r2 into r3;
    assert.eq r1 r3.receiver;
    assert.eq r3.is_active true;
    gt block.height r3.block_height into r4;
    sub block.height r3.block_height into r5;
    mul r5 r3.flow_rate into r6;
    ternary r4 r6 0u32 into r7;
    assert.neq r7 0u32;
    add r3.amount 1u32 into r8;
    assert.neq r7 r8;
    assert.eq r7 r3.amount;
    hash.bhp256 r3.sender into r9 as field;
    hash.bhp256 r3.receiver into r10 as field;
    get.or_use balances[r9] 0u32 into r11;
    gte r11 r7 into r12;
    assert.eq r12 true;
    sub r11 r7 into r13;
    set r13 into balances[r9];
    get.or_use balances[r10] 0u32 into r14;
    add r14 r7 into r15;
    set r15 into balances[r10];
    remove id_to_stream[r0];


function main:
    cast self.caller 1000u32 into r0 as token.record;
    hash.bhp256 self.caller into r1 as field;
    async main self.caller r1 into r2;
    output r0 as token.record;
    output r2 as hello.aleo/main.future;

finalize main:
    input r0 as address.public;
    input r1 as field.public;
    get.or_use balances[r1] 0u32 into r2;
    add r2 1000u32 into r3;
    set r3 into balances[r1];
