import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 800;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavBar(isMobile, context),
                _buildHeroSection(isMobile, context),
                _buildSectionTitle("⚽ Why Choose FutHub?"),
                _buildFeaturesSection(isMobile),
                _buildSectionTitle("📌 How It Works"),
                _buildHowItWorksSection(),
                _buildSectionTitle("🌟 What Players Say"),
                _buildSectionTitle("💰 Pricing Plans"),
                _buildPricingSection(),
                _buildSectionTitle("📞 Get in Touch"),
                _buildContactSection(),
                _buildFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  // ✅ Navigation Bar
  Widget _buildNavBar(bool isMobile, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "FutHub",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepOrange),
          ),
          if (!isMobile)
            Row(
              children: [
                _navItem("Home"),
                _navItem("Booking"),
                _navItem("About"),
                _navItem("Contact"),
              ],
            )
          else
            IconButton(
              icon: const Icon(Icons.menu, size: 28),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Navigation Menu Clicked")),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _navItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextButton(
        onPressed: () {},
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
      ),
    );
  }

  // ✅ Hero Section
  Widget _buildHeroSection(bool isMobile, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 80 : 120, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange, Colors.orangeAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Text(
            "Book Your Futsal Match Effortlessly!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: isMobile ? 28 : 40, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register'); // Ensure this route exists
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: const TextStyle(fontSize: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Get Started"),
          ),
        ],
      ),
    );
  }

  // ✅ Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Text(
        title,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ✅ Features Section
  Widget _buildFeaturesSection(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _featureBox("📅 Easy Booking", "Reserve your futsal match in seconds."),
          _featureBox("📊 Live Scores", "Track match scores in real-time."),
          _featureBox("💳 Secure Payments", "Safe and hassle-free transactions."),
        ],
      ),
    );
  }

  Widget _featureBox(String title, String description) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(description, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // ✅ How It Works Section
  Widget _buildHowItWorksSection() {
    return Column(
      children: [
        _stepBox("1️⃣ Sign Up", "Create an account in minutes."),
        _stepBox("2️⃣ Book a Court", "Select a futsal court and time slot."),
        _stepBox("3️⃣ Play & Enjoy", "Arrive on time and start playing!"),
      ],
    );
  }

  Widget _stepBox(String step, String description) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text(step, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
          const SizedBox(height: 5),
          Text(description, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // ✅ Pricing Section
  Widget _buildPricingSection() {
    return Column(
      children: [
        _pricingPlan("Standard", "NPR 1000/hour", "Get 15 min extra playtime"),
      ],
    );
  }

  Widget _pricingPlan(String plan, String price, String benefits) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(plan, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(price, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 10),
          Text(benefits, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // ✅ Contact Section
  Widget _buildContactSection() {
    return Column(
      children: const [
        Text("📞 Contact Us", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text("Email: support@futhub.com"),
        Text("Phone: +123 456 789"),
      ],
    );
  }

  // ✅ Footer
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.black,
      child: const Text(
        "© 2025 FutHub. All Rights Reserved.",
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
