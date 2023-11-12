import { Link } from "react-router-dom";

const Navbar = () => {
  return (
    <nav className="bg-black p-4 flex justify-between">
      <div className="flex items-center">
        <span className="text-white text-xl font-bold">StreamIT</span>
      </div>
      <div className="flex items-center">
        <button className="bg-white text-black px-6 py-2 mx-2 rounded-md">
          Mint Faucet Record
        </button>
        <button className="bg-white text-black px-6 py-2 mx-2 rounded-md">
          Stream Balance
        </button>
        <button className="bg-white text-black px-6 py-2 rounded-md">
          <Link to={`/withdraw`}> Withdraw</Link>
        </button>
        <button className="bg-white text-black px-6 py-2 mx-2 rounded-md">
          <Link to={`/cancel`}> Cancel</Link>
        </button>
      </div>
    </nav>
  );
};

export default Navbar;
