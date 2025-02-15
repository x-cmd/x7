import { chromium } from 'npm:playwright'

const url = Deno.args?.[0] || 'https://mistral.ai/en/news'
const state = Deno.args?.[1] || 'networkidle'

;(async function () {
    const browser = await chromium.launch({
        headless: true,
    })
    const page = await browser.newPage()
    await page.goto(url)
    await page.waitForLoadState(state)
    const htmlContent = await page.content()
    console.log(htmlContent)
    await browser.close()
}()).catch((err: Error) => {
    console.error(err)
})
