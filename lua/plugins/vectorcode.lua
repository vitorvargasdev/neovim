return {
  {
    "Davidyz/VectorCode",
    version = "*",                   -- optional, depending on whether you're on nightly or release
    build = "pipx upgrade vectorcode", -- optional but recommended if you set `version = "*"`
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("vectorcode").setup({
        -- number of retrieved documents
        n_query = 1,
      })
      local has_vc, vectorcode_config = pcall(require, "vectorcode.config")
      local vectorcode_cacher = nil
      if has_vc then
        vectorcode_cacher = vectorcode_config.get_cacher_backend()
      end

      -- roughly equate to 2000 tokens for LLM
      local RAG_Context_Window_Size = 16000

      provider_options = {
        openai_fim_compatible = { -- or codestral
          model = "qwen-2.5-coder:14b",
          template = {
            prompt = function(pref, suff, _)
              local prompt_message = ""
              if has_vc then
                for _, file in ipairs(vectorcode_cache.query_from_cache(0)) do
                  prompt_message = prompt_message
                      .. "<|file_sep|>"
                      .. file.path
                      .. "\n"
                      .. file.document
                end
              end

              prompt_message = vim.fn.strcharpart(prompt_message, 0, RAG_Context_Window_Size)

              return prompt_message
                  .. "<|fim_prefix|>"
                  .. pref
                  .. "<|fim_suffix|>"
                  .. suff
                  .. "<|fim_middle|>"
            end,
            suffix = false,
          },
        },
      }
    end,
  },
}
