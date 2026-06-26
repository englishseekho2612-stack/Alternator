import 'package:flutter/material.dart';
import '../../domain/models/membership_details.dart';
import '../controllers/monetization_controller.dart';

class SubscriptionSettingsView extends StatelessWidget {
  final MonetizationController controller;
  final String userId;

  const SubscriptionSettingsView({
    Key? key,
    required this.controller,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final profile = controller.profile;
        if (profile == null) {
          // Auto load profile on display
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.fetchProfile(userId);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final bool isPremium = profile.tier == MembershipTier.premium;
        final bool isTrial = profile.tier == MembershipTier.trial;
        final bool hasPremiumAccess = profile.hasPremiumAccess;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Apps Alternator Premium'),
            actions: [
              if (hasPremiumAccess)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade700,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'PREMIUM',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error Alert Banner
                if (controller.errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            controller.errorMessage!,
                            style: TextStyle(color: Colors.red.shade900),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: controller.clearError,
                        ),
                      ],
                    ),
                  ),

                // Subscription Plan Status Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Current Membership',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                            Text(
                              profile.tier.name.toUpperCase(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.black,
                                color: isPremium ? Colors.amber.shade800 : Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (isTrial) ...[
                          Text(
                            'Active 3-Day Free Trial',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: profile.trial.remainingDays / 3,
                            backgroundColor: Colors.grey.shade200,
                            color: Colors.blue,
                            minHeight: 6,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${profile.trial.remainingDays} days remaining of your premium free trial.',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                          ),
                        ] else if (isPremium) ...[
                          Text(
                            'Premium Monthly Subscriber',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Renews on ${profile.activeSubscription?.currentPeriodEnd.toLocal().toString().split(' ')[0]} for ₹199',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                          ),
                        ] else ...[
                          Text(
                            'Free Account Tier',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Upgrade to experience complete features with unlimited searches and zero ads.',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Pricing Card & Plans
                if (!isPremium) ...[
                  const Text(
                    'Available Subscriptions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.amber.shade700, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Apps Alternator Premium',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('Monthly recurring membership', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              Text(
                                '₹199/mo',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber.shade800,
                                    ),
                              ),
                            ],
                          ),
                          const Divider(height: 32),
                          const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 12),
                              Text('No Google AdMob ads'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 12),
                              Text('Unlimited Sanvi AI searches'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 12),
                              Text('Unlimited saved bookmarks & favorites'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 12),
                              Text('Priority cloud synchronization'),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber.shade700,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: controller.isLoading
                                  ? null
                                  : () async {
                                      final success = await controller.purchasePremium(userId);
                                      if (success) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Thank you! Welcome to Apps Alternator Premium.')),
                                        );
                                      }
                                    },
                              child: controller.isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('Subscribe Now via Razorpay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  // Premium Action Settings
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const Icon(Icons.cancel, color: Colors.red),
                      title: const Text('Cancel Active Subscription'),
                      subtitle: const Text('Cancel renewal of your Monthly Premium plan.'),
                      onTap: controller.isLoading
                          ? null
                          : () async {
                              final success = await controller.cancelActiveSubscription(userId);
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Subscription renewal cancelled successfully.')),
                                );
                              }
                            },
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Restore purchase & invoice triggers
                const Text(
                  'Membership Management',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.restore),
                  title: const Text('Restore Purchases'),
                  subtitle: const Text('Recover previously active Razorpay subscription state'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final success = await controller.restoreSubscription(userId);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Previous purchases restored successfully.')),
                      );
                    }
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.ad_units),
                  title: const Text('Google AdMob Preferences'),
                  subtitle: Text(
                    profile.hasAdsEnabled ? 'Banner Ads enabled (Supporting our free app)' : 'Ads disabled automatically (Premium active)',
                  ),
                  trailing: Switch(
                    value: profile.isAdPreferred,
                    onChanged: profile.hasPremiumAccess
                        ? null // Always disabled for premium
                        : (val) {
                            // Can toggle or display information modal
                          },
                  ),
                ),

                const SizedBox(height: 24),

                // Transaction & Invoices List
                if (profile.invoices.isNotEmpty) ...[
                  const Text(
                    'Transaction Invoice History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: profile.invoices.length,
                    itemBuilder: (context, index) {
                      final invoice = profile.invoices[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.receipt_long, color: Colors.blueGrey),
                          title: Text('Invoice ${invoice.transactionId}'),
                          subtitle: Text('Paid via ${invoice.paymentMethod.toUpperCase()} on ${invoice.date.toLocal().toString().split(' ')[0]}'),
                          trailing: Text(
                            '₹${invoice.amount}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
