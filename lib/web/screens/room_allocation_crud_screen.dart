import 'package:flutter/material.dart';
import '../../components/widgets/custom_date_field.dart';
import '../../components/widgets/custom_dropdown.dart';
import '../../components/widgets/custom_room_allocation_card.dart';
import '../../theme/theme.dart';
import 'package:intl/intl.dart'; // Para formatar a data exibida

class RoomAllocationCrudScreen extends StatefulWidget {
  const RoomAllocationCrudScreen({Key? key}) : super(key: key);

  @override
  _RoomAllocationCrudScreenState createState() => _RoomAllocationCrudScreenState();
}

class _RoomAllocationCrudScreenState extends State<RoomAllocationCrudScreen> {
  DateTime? _selectedDate;
  bool _isDateSelectionMode = true; // Inicia no modo de seleção de data

  // Controladores e valores para os filtros
  DropdownValueModel? _selectedPeriodo;
  DropdownValueModel? _selectedHorario;
  DropdownValueModel? _selectedBloco;
  String? _openFilterDropdown;

  // TODO: Substituir por dados reais/chamadas de serviço
  final List<DropdownValueModel> _periodos = [
    DropdownValueModel(value: 'manha', label: 'Manhã'),
    DropdownValueModel(value: 'tarde', label: 'Tarde'),
    DropdownValueModel(value: 'noite', label: 'Noite'),
  ];
  final List<DropdownValueModel> _horarios = [
    DropdownValueModel(value: 'aula1', label: 'Primeira Aula'),
    DropdownValueModel(value: 'aula2', label: 'Segunda Aula'),
    // ... mais horários
  ];
  final List<DropdownValueModel> _blocos = [
    DropdownValueModel(value: 'A', label: 'Bloco A'),
    DropdownValueModel(value: 'B', label: 'Bloco B'),
    // ... mais blocos
  ];

  // Lista de salas filtradas (mock)
  List<Map<String, dynamic>> _filteredRooms = [];

  // Turmas disponíveis mock (geralmente viria de uma consulta baseada na sala/data/horário)
  final List<DropdownValueModel> _availableClassesMock = [
    DropdownValueModel(value: 'turma1', label: 'Eng. Software - T1'),
    DropdownValueModel(value: 'turma2', label: 'Ciência Comp. - T2'),
  ];
  
  // Estado de alocação mock (roomId -> selectedClassValue)
  Map<String, DropdownValueModel?> _roomAllocations = {};
  // Estado de detalhes da turma alocada mock (roomId -> AllocatedClassDetails)
  Map<String, AllocatedClassDetails?> _allocatedClassDetailsMap = {};

  @override
  void initState() {
    super.initState();
    // Inicialmente, nenhuma sala é carregada até que os filtros sejam aplicados
  }

  void _onDateSelectedForScreen(DateTime? date) {
    setState(() {
      _selectedDate = date;
      if (date != null) {
        _isDateSelectionMode = false; // Sai do modo de seleção de data
        _applyFilters(); // Aplica filtros iniciais ou carrega dados
      }
    });
  }

  void _handleFilterDropdownOpen(String dropdownId) {
    setState(() {
      _openFilterDropdown = dropdownId;
    });
  }

  void _applyFilters() {
    // Lógica de filtragem (mock por enquanto)
    // Aqui você faria uma chamada de serviço/API com _selectedDate, _selectedPeriodo, _selectedHorario, _selectedBloco
    print('Aplicando filtros:');
    print('Data: ${_selectedDate}');
    print('Período: ${_selectedPeriodo?.label}');
    print('Horário: ${_selectedHorario?.label}');
    print('Bloco: ${_selectedBloco?.label}');

    // Mock: Simula o carregamento de algumas salas
    setState(() {
      _filteredRooms = [
        {
          'id': 'sala101',
          'name': 'Sala 101',
          'block': 'Bloco A',
          'desksCount': 30,
          'hasTV': true,
          'hasProjector': false,
        },
        {
          'id': 'sala102',
          'name': 'Sala 102',
          'block': 'Bloco A',
          'desksCount': 25,
          'hasTV': true,
          'hasProjector': true,
        },
        {
          'id': 'labInf',
          'name': 'Laboratório de Informática',
          'block': 'Bloco B',
          'desksCount': 20,
          'hasTV': false,
          'hasProjector': true,
        },
      ];
      // Limpa alocações anteriores ao aplicar novos filtros gerais
      _roomAllocations = {}; 
      _allocatedClassDetailsMap = {};
    });
  }

  void _onClassSelectedInCard(String roomId, DropdownValueModel? selectedClass) {
    setState(() {
      _roomAllocations[roomId] = selectedClass;
      if (selectedClass != null) {
        // Mock: Simula o carregamento dos detalhes da turma alocada
        // Em um caso real, você buscaria os dados da turma (professor, disciplina, horário)
        _allocatedClassDetailsMap[roomId] = AllocatedClassDetails(
          teacher: 'Prof. Mock ${selectedClass.label.substring(0,3)}',
          subject: 'Disc. Mock ${selectedClass.label.split("-").last.trim()}',
          time: _selectedHorario?.label ?? 'Horário Mock',
        );
      } else {
        _allocatedClassDetailsMap.remove(roomId);
      }
    });
    print('Sala $roomId alocou turma: ${selectedClass?.label}');
  }

  Widget _buildDateSelectionForm() {
    final Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        constraints: BoxConstraints(maxWidth: screenSize.width * (screenSize.width > 600 ? 0.4 : 0.8)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Selecionar Data para Alocação', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.verdeUNICV)),
            const SizedBox(height: 24),
            CustomDateField(
              label: 'Data da Alocação',
              onChanged: _onDateSelectedForScreen,
              firstDate: DateTime.now().subtract(const Duration(days: 30)), // Exemplo: 30 dias no passado
              lastDate: DateTime.now().add(const Duration(days: 365)),   // Exemplo: 1 ano no futuro
            ),
            const SizedBox(height: 16),
            // O botão de "Confirmar" está implícito na seleção da data no CustomDateField (onChanged)
            // Se precisar de um botão explícito, pode ser adicionado aqui.
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersRow() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final Size screenSize = MediaQuery.of(context).size;
    bool isSmallScreen = screenSize.width < 700; // Ponto de quebra para layout de filtros

    List<Widget> filterWidgets = [
      Expanded(
        flex: isSmallScreen ? 2 : 1,
        child: CustomDropdown(
          label: 'Período',
          items: _periodos,
          selectedValue: _selectedPeriodo,
          onChanged: (val) => setState(() { _selectedPeriodo = val; _applyFilters(); }),
          dropdownId: 'periodo_filter',
          openDropdownId: _openFilterDropdown,
          onOpen: () => _handleFilterDropdownOpen('periodo_filter'),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        flex: isSmallScreen ? 2 : 1,
        child: CustomDropdown(
          label: 'Horário',
          items: _horarios,
          selectedValue: _selectedHorario,
          onChanged: (val) => setState(() { _selectedHorario = val; _applyFilters(); }),
          dropdownId: 'horario_filter',
          openDropdownId: _openFilterDropdown,
          onOpen: () => _handleFilterDropdownOpen('horario_filter'),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        flex: isSmallScreen ? 2 : 1,
        child: CustomDropdown(
          label: 'Bloco',
          items: _blocos,
          selectedValue: _selectedBloco,
          onChanged: (val) => setState(() { _selectedBloco = val; _applyFilters(); }),
          dropdownId: 'bloco_filter',
          openDropdownId: _openFilterDropdown,
          onOpen: () => _handleFilterDropdownOpen('bloco_filter'),
        ),
      ),
      const SizedBox(width: 16),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Ajuste para alinhar visualmente com dropdowns
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.verdeUNICV.withOpacity(0.5), width: 1),
            borderRadius: BorderRadius.circular(20)
        ),
        child: InkWell(
          onTap: () => setState(() => _isDateSelectionMode = true), // Volta para seleção de data
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_today, color: AppColors.verdeUNICV, size: 18),
              const SizedBox(width: 8),
              Text(
                _selectedDate != null ? formatter.format(_selectedDate!) : 'N/A',
                style: const TextStyle(fontSize: 15, color: AppColors.verdeUNICV, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    ];

    if (isSmallScreen) {
      return Column(
        children: [
          Row(children: filterWidgets.sublist(0, 3)), // Período, Horário, Bloco
          const SizedBox(height: 8),
          Row(children: [Expanded(child: filterWidgets[4])]), // Data (ocupa a linha inteira)
        ],
      );
    } else {
        return Row(children: filterWidgets);
    }
  }

  Widget _buildRoomsGrid() {
    if (_filteredRooms.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text('Nenhuma sala encontrada para os filtros selecionados.', textAlign: TextAlign.center)));
    }
    // Usando Wrap para responsividade similar ao GridView mas mais flexível com alturas variáveis de cards
    return Wrap(
      spacing: 8.0, // Espaço horizontal entre cards
      runSpacing: 8.0, // Espaço vertical entre linhas de cards
      children: _filteredRooms.map((roomData) {
        String roomId = roomData['id'];
        return CustomRoomAllocationCard(
          roomId: roomId,
          roomName: roomData['name'],
          roomBlock: roomData['block'],
          roomDesksCount: roomData['desksCount'],
          roomHasTV: roomData['hasTV'],
          roomHasProjector: roomData['hasProjector'],
          availableClasses: _availableClassesMock, // Usar dados mock
          selectedClassValue: _roomAllocations[roomId],
          allocatedClassDetails: _allocatedClassDetailsMap[roomId],
          onClassSelected: _onClassSelectedInCard,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      body: _isDateSelectionMode
          ? _buildDateSelectionForm()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alocação de Salas',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.verdeUNICV,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildFiltersRow(),
                  const SizedBox(height: 24),
                  _buildRoomsGrid(),
                ],
              ),
            ),
    );
  }
}
