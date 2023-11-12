
const WithdrawPage = () => {

  return (
    <div className="w-1/2 mx-auto mt-8">
      <div className="mb-2">
        <label htmlFor="withdrawAmount" className="block mb-1 font-semibold">
          Enter Unique ID
        </label>
        <input
          type="text"
          id="withdrawAmount"
          name="withdrawAmount"
          
          placeholder="Enter the hash ID ..."
          className="border border-gray-300 px-4 py-2 rounded-md w-full"
        />
      </div>
      <button
        
        className="bg-black text-white px-4 py-2 rounded-md w-full"
      >
        Withdraw
      </button>
    </div>
  );
};

export default WithdrawPage;
