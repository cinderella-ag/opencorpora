# encoding: utf-8
counter = 0  # общий счетчик

with open('pools\pools.txt', 'r') as file:
    result = open('examples.txt', 'w', encoding='utf8')
    for s in file:

        s = s.split("\t")

        if s[1] == 'NOUN&sing&nomn@NOUN&sing&accs' and s[2].strip() == "9":
            index = s[0]
            file_name = 'pools\pool_' + index + '.tab'

            temp = 0  # счетчик примеров в каждом файле
            with open(file_name, 'r', encoding='utf8') as f:
                for s in f:

                    this_string = s
                    s = s.split("\t")
                    s[len(s) - 1] = s[len(s) - 1].strip()

                    flag = True

                    start = 0
                    while True:
                        if s[start] == 'NOUN & sing & accs' or s[start] == 'NOUN & sing & nomn':
                            break
                        if s[start] == 'Other':
                            flag = False
                            break
                        start += 1

                    end = len(s) - 1
                    while True:
                        if s[end] == 'NOUN & sing & accs' or s[end] == 'NOUN & sing & nomn':
                            break
                        if s[end] == 'Other':
                            flag = False
                            break
                        end -= 1

                    if flag and s[start] != s[end]:
                        for i in range(start + 1, end):
                            if s[i] != s[start]:
                                flag = False
                                break

                        if flag:
                            counter += 1
                            temp += 1
                            result.write(this_string)

            f.close()
    result.close()
file.close()
print('counter = ', counter)
