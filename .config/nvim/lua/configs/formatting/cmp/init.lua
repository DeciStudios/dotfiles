local cmp = require('cmp')
local luasnip = require('luasnip')



cmp.setup(require('configs.formatting.cmp.opts'))

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?`
-- cmp.setup.cmdline({ '/', '?' }, {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = {
--         { name = 'buffer' }
--     }
-- })

-- Use cmdline & path source for ':'
-- cmp.setup.cmdline(':', {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = cmp.config.sources({
--         { name = 'path' }
--     }, {
--         { name = 'cmdline' }
--     })
-- })

-- Setup autopairs integration
local has_autopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if has_autopairs then
    cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
    )
end
