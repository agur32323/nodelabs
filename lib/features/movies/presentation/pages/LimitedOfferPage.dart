import 'dart:ui';
import 'package:flutter/material.dart';

void showLimitedOfferPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2C0B0B), Color(0xFF000000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Sınırlı Teklif",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                const Text(
                  "Jeton paketini seçerek bonus kazan\nve yeni bölümlerin kilidini açın!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 18),

                const Text(
                  "Alacağınız Bonuslar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _BonusItem(icon: Icons.diamond, title: "Premium\nHesap"),
                      _BonusItem(
                        icon: Icons.favorite,
                        title: "Daha Fazla\nEşleşme",
                      ),
                      _BonusItem(icon: Icons.upload, title: "Öne\nÇıkarma"),
                      _BonusItem(
                        icon: Icons.thumb_up,
                        title: "Daha Fazla\nBeğeni",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  "Kilidi açmak için bir jeton paketi seçin",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _PackageCard(
                        bonus: "+10%",
                        oldPrice: "200",
                        newPrice: "330",
                        price: "₺99,99",
                        isSelected: true,
                      ),
                      _PackageCard(
                        bonus: "+70%",
                        oldPrice: "2.000",
                        newPrice: "3.375",
                        price: "₺799,99",
                        highlight: true,
                      ),
                      _PackageCard(
                        bonus: "+35%",
                        oldPrice: "1.000",
                        newPrice: "1.350",
                        price: "₺399,99",
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Tüm Jetonları Gör",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

class _BonusItem extends StatelessWidget {
  final IconData icon;
  final String title;
  const _BonusItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.pinkAccent, Colors.redAccent.shade200],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.pinkAccent.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 11),
        ),
      ],
    );
  }
}

class _PackageCard extends StatelessWidget {
  final String bonus;
  final String oldPrice;
  final String newPrice;
  final String price;
  final bool isSelected;
  final bool highlight;

  const _PackageCard({
    required this.bonus,
    required this.oldPrice,
    required this.newPrice,
    required this.price,
    this.isSelected = false,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: highlight
              ? [Colors.deepPurple, Colors.purpleAccent]
              : [Colors.red.shade400, Colors.red.shade700],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: Colors.greenAccent, width: 2)
            : null,
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Text(
            bonus,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            oldPrice,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Text(
            newPrice,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const Text(
            "Jeton",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const Text(
            "Başına haftalık",
            style: TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
