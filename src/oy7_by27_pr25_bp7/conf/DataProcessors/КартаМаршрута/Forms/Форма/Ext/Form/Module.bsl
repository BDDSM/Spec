﻿
&НаСервере
Процедура ОбновитьКартуНаСервере()
	Карта = БП.ПолучитьОбъект().ПолучитьКартуМаршрута();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКарту(Команда)
	ОбновитьКартуНаСервере();
КонецПроцедуры
