import { useState } from "react";

const StreamInputPage = () => {
  
  const [inputs, setInputs] = useState({
    input1: "",
    input2: "",
    input3: "",
      });

  const handleInputChange = (event) => {
    const { name, value } = event.target;
    setInputs((prevInputs) => ({
      ...prevInputs,
      [name]: value,
    }));
  };

  const handleStartButtonClick = async () => {
    const prepStreamInfoStruct = {
      sender: address,
      receiver: inputs.input1,
      amount_to_be_stream: parseInt(inputs.input2),
      flow_rate: parseInt(inputs.input3),
    };
    const resp = await createStream(account, prepStreamInfoStruct);
    console.log(inputs);
    setInputs({ input1: "", input2: "", input3: "" });
    console.log(resp);
  };

  return (
    <div className="w-1/2 mx-auto p-4">
      <div className="mb-2">
        <label htmlFor="input1" className="block mb-1 font-semibold">
          Receiver Address
        </label>
        <input
          type="text"
          id="input1"
          name="input1"
          value={inputs.input1}
          onChange={handleInputChange}
          placeholder="Receiver public address, wallet address"
          className="border border-gray-300 px-4 py-2 rounded-md w-full"
        />
      </div>
      <div className="mb-2">
        <label htmlFor="input2" className="block mb-1 font-semibold">
          Amount
        </label>
        <input
          type="text"
          id="input2"
          name="input2"
          value={inputs.input2}
          onChange={handleInputChange}
          placeholder="Amount to be streamed"
          className="border border-gray-300 px-4 py-2 rounded-md w-full"
        />
      </div>
      <div className="mb-2">
        <label htmlFor="input3" className="block mb-1 font-semibold">
          Flow Rate
        </label>
        <input
          type="text"
          id="input3"
          name="input3"
          value={inputs.input3}
          onChange={handleInputChange}
          placeholder="Put whole number like 1, 2, 3"
          className="border border-gray-300 px-4 py-2 rounded-md w-full"
        />
      </div>
      <button
        onClick={handleStartButtonClick}
        className="bg-black text-white px-4 py-2 rounded-md w-full"
      >
        Start
      </button>
    </div>
  );
};

export default StreamInputPage;
