# Glow Lab — Game Design Document (MVP)

> Phiên bản: MVP v0.1
> Thể loại: 2D casual / matching / beauty sim
> Nền tảng: iOS + Android (Unity, portrait)
> Người làm: 1 dev beginner

---

## 1. Pitch một câu

Bạn là chủ một beauty studio nhỏ. Khách bước vào với một "vibe" muốn có, bạn chọn foundation, blush, lip, glow sao cho đúng tone và đúng dịp, rồi nhận điểm và coins để mở khoá sản phẩm mới.

## 2. Core gameplay loop

1. Khách xuất hiện kèm một câu yêu cầu (vd: *"Clean girl look for brunch"*).
2. Màn hình hiện khuôn mặt + skin tone + undertone của khách.
3. Người chơi chọn 4 món: Foundation / Blush / Lip / Glow. Preview cập nhật real-time trên mặt.
4. Bấm **Reveal look** để chấm điểm.
5. Game tính điểm: shade match + color harmony + occasion match + time bonus.
6. Nhận coins theo điểm, mở khoá sản phẩm mới, sang khách tiếp theo.

Vòng lặp này dài khoảng 20-40 giây mỗi khách. Đó là đơn vị "fun" cần test đầu tiên.

## 3. Screens (MVP)

| Screen | Nội dung |
|--------|----------|
| Home | Logo, số coins, nút Open Studio, (sau này) phòng vanity |
| Game | Card yêu cầu của khách, khuôn mặt preview, 4 hàng swatch sản phẩm, nút Reveal, timer |
| Result | Breakdown điểm từng tiêu chí, số sao, coins nhận được, nút Next |
| Shop/Unlock | Có thể gộp vào Home ở MVP: danh sách item khoá + giá coins |

## 4. Product categories

Theo concept gốc, đầy đủ 4 nhóm (bản prototype dùng full set này để game chơi được trọn vẹn; con số "12" trong note ban đầu là ước lượng, thực tế nên đủ 17 món base + 3 món unlock):

- **Foundation** (có tone + undertone): 00, 0N, 1N, 2N, 3W
- **Blush**: pink, berry, coral, peach
- **Lip**: oil, balm, gloss, matte
- **Glow**: pearl, champagne, rose, bronze
- **Unlock (3 món mới)**: vd Foundation 1W (warm), Blush mauve, Glow holographic

> Lưu ý branding: sản phẩm chỉ "inspired by luxury makeup", đặt tên riêng (vd "Velvet Veil Foundation"), tuyệt đối không dùng tên thương hiệu thật.

## 5. Customer data structure

```json
{
  "id": "c01",
  "name": "Mai",
  "request": "I want a clean girl look for brunch.",
  "skinTone": "fair",
  "undertone": "neutral",
  "occasion": "brunch",
  "preferredBlush": "peach",
  "preferredLip": "balm",
  "preferredGlow": "pearl"
}
```

- `skinTone`: fair | light | medium | tan
- `undertone`: cool | neutral | warm
- `occasion`: brunch | date night | beach | office | wedding ...

## 6. Product data structure

```json
{
  "id": "fnd_0N",
  "category": "foundation",
  "name": "0N Ivory",
  "tone": "fair",
  "undertone": "neutral",
  "swatch": "#EFD2BE",
  "locked": false,
  "price": 0
}
```

## 7. Scoring rules (MVP, đơn giản nhưng đủ "ăn tiền")

Tổng điểm tối đa ~125. Foundation sai là phạt nặng nhất (giống đời thật).

**Foundation (tối đa 40)**
- Tone đúng: +30 / lệch 1 bậc: +10 / lệch 2+ bậc: **-20**
- Undertone đúng: +10

**Blush / Lip / Glow (mỗi món tối đa 20)**
- Đúng preferred: +20
- Cùng "nhiệt độ màu" (warm/cool) với preferred: +8
- Còn lại: +2 đến +4

**Color harmony (tối đa +10)**
- Blush + Lip + Glow cùng tông nhiệt (hoặc có món neutral): +10

**Time bonus (tối đa +15)**
- Thưởng theo thời gian còn lại

**Quy đổi:**
- Coins nhận = round(tổng điểm / 4)
- Sao: ≥95 → 3 sao, ≥65 → 2 sao, ≥35 → 1 sao

## 8. MVP feature checklist

- [x] 1 Home, 1 Game, 1 Result
- [x] 5 khách mẫu
- [x] Bộ sản phẩm đủ 4 nhóm
- [x] Hệ thống điểm 4 tiêu chí
- [x] Coins
- [x] Unlock 3 món
- [x] Không login, không payment, không 3D
- [x] Real-time preview makeup trên mặt

## 9. Future features (sau MVP)

- Rewarded ads để nhận coins
- Cosmetic packs (mua bằng coins)
- Daily challenge
- Limited event: "Wedding Makeup Week"
- Vanity room decor để unlock
- Nhiều khách hơn + độ khó tăng dần
- Hệ thống sao/cấp độ studio

## 10. Unity implementation plan (cho beginner)

Thứ tự build, mỗi bước là 1 cột mốc chạy được:

1. **Setup**: Unity 2D project, portrait, import data JSON (customers + products) vào Scriptable Objects hoặc đọc từ file JSON.
2. **UI Game screen**: Canvas + 4 hàng swatch (dùng prefab Button), card yêu cầu khách, khung mặt.
3. **Selection logic**: bấm swatch → lưu lựa chọn → update preview (đổi màu Image cho blush/lip/glow).
4. **Scoring**: viết `ScoreCalculator` thuần C# (không phụ thuộc UI) để dễ test.
5. **Result screen**: hiện breakdown + sao + coins.
6. **Coins + Unlock**: lưu coins (PlayerPrefs cho MVP), khoá/mở swatch.
7. **Polish**: animation nhẹ (DOTween), sound bấm/điểm, transition giữa khách.
8. **Build test**: build lên iPhone/Android, chỉnh safe area.

> Mẹo: tách hẳn **logic (data + scoring)** khỏi **UI**. Bản prototype web đi kèm chính là bản tham chiếu cho data và công thức scoring — port thẳng sang C# là được.

---

*File này là bản nháp MVP. Khi gameplay đã "vui" qua test prototype, mới mở rộng scope.*
