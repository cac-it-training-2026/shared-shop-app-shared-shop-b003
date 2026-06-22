function playGacha() {
    const btn = document.getElementById('btnPlayGacha');
    const img = document.getElementById('gachaEmoji');
    const result = document.getElementById('gachaResult');
    const animation = document.getElementById('gachaAnimation');

    const contextPath = document.body.dataset.contextPath || '/shared_shop';

    console.log("playGacha called");
    btn.disabled = true;
    img.classList.add('shaking');

    // 非同期でガチャ実行
    // パス末尾のスラッシュを考慮
    const url = contextPath.endsWith('/') ? contextPath + 'client/gacha/play' : contextPath + '/client/gacha/play';
    console.log("Fetching URL:", url);
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => {
        console.log("Response received:", response.status);
        return response.json();
    })
    .then(data => {
        console.log("Data received:", data);
        setTimeout(() => {
            console.log("Showing result");
            img.classList.remove('shaking');
            btn.style.display = 'none';
            result.style.display = 'block';

            const message = document.getElementById('resultMessage');
            const couponInfo = document.getElementById('couponInfo');

            if (data.status === 'win') {
                message.innerText = 'おめでとうございます！あたりです！';
                couponInfo.style.display = 'block';
                document.getElementById('couponCode').innerText = data.couponCode;

                let discountText = '';
                if (data.discountType === 'amount') {
                    discountText = data.discountValue + '円引き';
                } else {
                    discountText = data.discountValue + '% OFF';
                }
                document.getElementById('discountInfo').innerText = discountText;
            } else if (data.status === 'lose') {
                message.innerText = '残念！はずれです。また次回挑戦してください！';
                couponInfo.style.display = 'none';
            } else {
                message.innerText = 'エラーが発生しました：' + data.message;
            }
        }, 2000); // 2秒間演出
    })
    .catch(error => {
        console.error('Error:', error);
        img.classList.remove('shaking');
        btn.disabled = false;
        alert('エラーが発生しました。');
    });
}

function closeGacha() {
    const contextPath = document.body.dataset.contextPath || '/shared_shop';

    // 権限消費のためにサーバーに通知
    const url = contextPath.endsWith('/') ? contextPath + 'client/gacha/cancel' : contextPath + '/client/gacha/cancel';
    fetch(url, {
        method: 'POST'
    }).finally(() => {
        document.getElementById('gachaModal').style.display = 'none';
    });
}
