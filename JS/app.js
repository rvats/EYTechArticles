const API_KEY = "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";

async function fetchData() {
    const response = await fetch("https://api.openai.com/v1/completions", {
        method: "POST",
        headers: {
            Authorization: `Bearer ${API_KEY}`,
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            model: "text-davinci-003",
            prompt: "Hello, How are you today?",
            max_tokens: 7
        })
    })
    const data = await response.json();
    console.log(data);
}
fetchData();