import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; 
import '../../../../core/auth_provider.dart'; 
import 'main_screen.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  bool _hasAccepted = false;
  bool _isLoading = false; 

  Future<void> _handleAcceptance() async {
    setState(() => _isLoading = true);
    
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    try {
      // 1. Chama a função que envia o PATCH para o Render e atualiza o Neon
      await auth.acceptTerms();
      
      if (mounted) {
        // 2. VERIFICAÇÃO DE SEGURANÇA: 
        // Só avançamos se o status no AuthProvider agora for 'true'.
        // Isso impede que o app entre em loop caso o servidor falhe.
        if (auth.user?.termsAccepted == true) {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => const MainScreen())
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("O servidor não confirmou o aceite. Tente novamente."),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro de conexão com o servidor.")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color iJudeBlue = Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Termos de Serviço", 
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, 
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Leia atentamente nossas diretrizes:",
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Estes Termos de Serviço regem o uso do aplicativo iJude. "
                    "Ao utilizar nossa plataforma, você concorda com a coleta de dados necessária "
                    "para a prestação de serviços e segurança das transações.\n\n"
                    "1. Privacidade: Seus dados de contato são compartilhados apenas após a confirmação do pedido.\n\n"
                    "2. Pagamentos: Taxas de cancelamento podem ser aplicadas conforme as regras vigentes.\n\n"
                    "3. Conduta: Esperamos respeito mútuo entre clientes e profissionais.\n\n"
                    "Ao marcar a caixa abaixo, você confirma que leu e concorda com todas as diretrizes.",
                    style: GoogleFonts.inter(color: const Color(0xFF64748B), height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          
          // Rodapé fixo com Checkbox e Botão
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _hasAccepted,
                      onChanged: (val) => setState(() => _hasAccepted = val!),
                      activeColor: iJudeBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    const Expanded(
                      child: Text("Eu li e aceito os termos de uso e privacidade."),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (_hasAccepted && !_isLoading) ? _handleAcceptance : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: iJudeBlue,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isLoading 
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                        )
                      : const Text(
                          "Continuar", 
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}