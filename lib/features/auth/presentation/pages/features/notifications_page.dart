import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // 1. TODAS INICIAM COMO NÃO LIDAS (isUnread: true)
  List<Map<String, dynamic>> notifications = [
    {
      "title": "Profissional a caminho!",
      "body": "O eletricista João Carlos está indo para o seu endereço.",
      "time": "2 min atrás",
      "type": "order",
      "isUnread": true, 
    },
    {
      "title": "Orçamento Recebido",
      "body": "Você recebeu uma nova proposta para o serviço de Pintura.",
      "time": "1 hora atrás",
      "type": "offer",
      "isUnread": true,
    },
    {
      "title": "Pagamento Aprovado",
      "body": "Seu pagamento de R\$ 150,00 foi confirmado com sucesso.",
      "time": "Ontem",
      "type": "payment",
      "isUnread": true, // Mudado para true
    },
    {
      "title": "Bem-vindo ao iJude!",
      "body": "Complete seu perfil para ter mais chances de conseguir bons profissionais.",
      "time": "3 dias atrás",
      "type": "system",
      "isUnread": true, // Mudado para true
    },
  ];

  // Função para limpar tudo
  void _clearNotifications() {
    setState(() {
      notifications.clear();
    });
  }

  // 2. NOVA FUNÇÃO: Marcar apenas uma como lida ao clicar
  void _markAsRead(int index) {
    setState(() {
      notifications[index]['isUnread'] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color iJudeNavy = Color(0xFF0F172A);
    const Color iJudeBackground = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: iJudeBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: iJudeNavy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Notificações",
          style: GoogleFonts.inter(
            color: iJudeNavy,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: notifications.isNotEmpty ? _clearNotifications : null,
            child: Text(
              "Limpar",
              style: GoogleFonts.inter(
                color: notifications.isNotEmpty 
                    ? const Color(0xFF2563EB) 
                    : Colors.grey.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _NotificationCard(
                  data: notifications[index],
                  // Passamos a função de marcar como lida para o card
                  onTap: () => _markAsRead(index),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "Sem notificações",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap; // Recebe a ação de clique

  const _NotificationCard({
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color iJudeNavy = Color(0xFF0F172A);
    final bool isUnread = data['isUnread'];

    // Envolvemos o Container em GestureDetector para detectar o toque
    return GestureDetector(
      onTap: onTap, 
      child: AnimatedContainer( // Usamos AnimatedContainer para transição suave da cor
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Lógica visual: Se não lida = Branco, Se lida = Cinza (igual as ultimas do print)
          color: isUnread ? Colors.white : const Color(0xFFF1F5F9), 
          borderRadius: BorderRadius.circular(16),
          border: isUnread ? Border.all(color: const Color(0xFFE2E8F0)) : null,
          boxShadow: isUnread
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(data['type']),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          data['title'],
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: iJudeNavy,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Bolinha vermelha só aparece se não lida
                      if (isUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['body'],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data['time'],
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'order':
        icon = Icons.local_shipping_outlined;
        color = Colors.blue;
        break;
      case 'offer':
        icon = Icons.attach_money;
        color = Colors.green;
        break;
      case 'payment':
        icon = Icons.credit_card;
        color = Colors.purple;
        break;
      default:
        icon = Icons.notifications_none;
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}