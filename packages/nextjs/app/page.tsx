"use client";

import { useRef } from "react";
import type { NextPage } from "next";
import { toHex } from "viem";
import { useScaffoldWriteContract } from "~~/hooks/scaffold-eth";

const Home: NextPage = () => {
  const { writeContractAsync, isPending, isSuccess } = useScaffoldWriteContract({
    contractName: "DonorRegistration",
  });
  const registerDonorFormRef = useRef<HTMLFormElement>(null);

  async function registerDonor(formdata: FormData) {
    const name = toHex(formdata.get("name")?.toString() ?? "", { size: 32 });
    const id = BigInt(formdata.get("id")?.toString() ?? 0);
    const bloodGroup = toHex(formdata.get("bloodGroup")?.toString() ?? "", { size: 32 });

    try {
      await writeContractAsync({
        functionName: "registerDonor",
        args: [id, name, bloodGroup],
      });
    } catch (e) {
      console.error(e);
    }

    if (isSuccess) {
      console.log("success");
      registerDonorFormRef.current?.reset();
    }
  }

  return (
    <>
      <form ref={registerDonorFormRef} action={registerDonor} className="my-10 container space-y-5 max-w-96 mx-auto">
        <label className="input input-bordered flex items-center gap-2">
          <input type="number" name="id" className="grow" min={1} placeholder="Enter ID" required />
        </label>
        <label className="input input-bordered flex items-center gap-2">
          <input type="text" name="name" className="grow" placeholder="Enter name" required />
        </label>
        <label className="flex items-center gap-2">
          <select name="bloodGroup" className="select select-bordered grow" required>
            <option value="" selected>
              Choose Blood Group
            </option>
            <option value="A">A</option>
            <option value="B">B</option>
            <option value="AB">AB</option>
            <option value="O">O</option>
            <option value="A-">A-</option>
            <option value="A+">A+</option>
            <option value="B+">B+</option>
            <option value="B-">B-</option>
            <option value="AB+">AB+</option>
          </select>
        </label>
        <button type="submit" className="btn w-24 btn-primary" disabled={isPending}>
          {isPending ? <span className="loading loading-spinner loading-md"></span> : "Register"}
        </button>
      </form>
    </>
  );
};

export default Home;
