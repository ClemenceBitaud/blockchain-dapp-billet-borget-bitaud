<template>
  <div v-if="isDrizzleInitialized">
    <drizzle-contract contractName="Token" method="totalSupply" label="Total" />
    <drizzle-contract contractName="Token" method="symbol" label="Symbol" />
    <drizzle-contract
      contractName="Token"
      method="balanceOf"
      label="Your Balance"
      :methodArgs="accounts"
    />

    <drizzle-contract-form
      contractName="Token"
      method="transfer"
      :placeholders="placeholders"
    />
  </div>

  <div v-else>Loading...</div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  name: "Token",
  computed: {
    ...mapGetters("accounts", ["activeAccount", "activeBalance"]),
    ...mapGetters("drizzle", ["isDrizzleInitialized"]),

    accounts() {
      return [this.activeAccount];
    },

    placeholders() {
      return ["To Address", "Amount to Send"];
    },
  },
};
</script>

<style></style>
