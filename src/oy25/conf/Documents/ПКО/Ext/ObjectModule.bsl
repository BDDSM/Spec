﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ЗадолженностьПоОплате");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Контрагент", Контрагент);
	Блокировка.Заблокировать();
	
	Движения.ЗадолженностьПоОплате.Очистить();
	Движения.ЗадолженностьПоОплате.Записать();
	Движения.ЗадолженностьПоОплате.Записывать = Истина;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗадолженностьПоОплатеОстатки.Счет КАК Счет,
		|	ЗадолженностьПоОплатеОстатки.СуммаОстаток КАК СуммаОстаток
		|ИЗ
		|	РегистрНакопления.ЗадолженностьПоОплате.Остатки(, Контрагент = &Контрагент) КАК ЗадолженностьПоОплатеОстатки
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗадолженностьПоОплатеОстатки.Счет.МоментВремени");
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ОсталосьСписать = СуммаДокумента;
	
	Пока Выборка.Следующий() И ОсталосьСписать > 0 Цикл
		Списать = Мин(ОсталосьСписать, Выборка.СуммаОстаток);
		
		Движение = Движения.ЗадолженностьПоОплате.ДобавитьРасход();
		Движение.Период		 = Дата;
		Движение.Контрагент	 = Контрагент;
		Движение.Счет		 = Выборка.Счет;
		Движение.Сумма		 = Списать;
		
		ОсталосьСписать = ОсталосьСписать - Списать;
	КонецЦикла;
КонецПроцедуры
