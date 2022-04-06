# DA-HongKongProtest_Article
비정형데이터분석(TopicModeling, NetworkAnalysis) - 홍콩시위에 대한 토픽모델링 및 네트워크 분석

분석일자 : 2019. 12. 2.

## I. 서론
#### 키워드 선정
- 키워드 선정 이유

  - ‘홍콩시위’를 분석하게 된 이유, 

  - 첫 번째로 ‘홍콩시위’에 대해서 자세하게 아는 게 없었기 때문이다. 다양한 언론사의 뉴스와 실시간 검색어에 자주 올라올 정도로 ‘홍콩시위’라는 키워드가 해당 해의 매우 큰 이슈였다는 것은 알고 있었지만, 그 자세한 내막은 사실상 모르고 있는 상태였다. 따라서 이번 네트워크 분석을 이용해서 배경 지식 없이 얼마나 해당 주제에 대해서 알 수 있는지 ‘홍콩시위’를 키워드로 네트워크 분석을 해보게 되었다. 

  - 두 번째는 ‘홍콩시위’라는 키워드가 앞에서 언급한 것처럼, 매우 유명한 만큼 이와 관련된 다양한 뉴스들의 양이 분석하기에는 충분할 거라는 판단이 들었다. 데이터의 양이 많아야 더욱 정확하고 상세한 내용을 다룰 수 있고, 키워드의 여러 가지 다양한 주제 확인할 수 있기 때문이다. 특히, 해당 사건은 중국이라는 강대국이 엮여 있었기 때문에, 이와 관련된 뉴스는 충분할 거라 생각되었다.

  - 마지막으로, 해당 시위가 어떠한 영향을 미쳤는지 각 키워드의 연관성을 알아보기에는 네트워크 분석이 제일 적합하다고 생각되어 이번 분석을 시행하게 되었다.

#### 데이터 수집
- BIG KINDS

![image](https://user-images.githubusercontent.com/59859965/161910886-89ac4cda-043e-491f-adad-f0dff2321132.png)

우선 데이터는 BIG KINDS라는 사이트에서 ‘홍콩 시위’를 검색어로 ‘9월 2일 ~ 12월 2일’ 사이의 뉴스를 찾아보았다. 총 6,306건의 ‘홍콩 시위’와 관련된 뉴스를 찾을 수 있었다. 꽤 많은 양의 데이터였기에 분석하기에는 충분한 양이라는 생각이 들었다.

## II. 본론

#### 토픽모델링을 이용한 주제파악

‘HCN(Hyper-Connected News)’를 다룬 LDA 코드를 활용해서 토픽모델링을 실시.
![image](https://user-images.githubusercontent.com/59859965/161910941-42ee5247-2ce4-4838-b0ff-eacf43cd6544.png)


- 주제를 4개로 나눴을 때, 전체적으로 서로 다른 내용을 다루고 있다는 것이 확실하게 느껴졌다. 

  1. 첫 번째 토픽은 중국의 송환법 철회와 정부 내의 이야기를 다루고 있었고, 

  2. 두 번째 토픽은 홍콩, 중국, 미국의 전체적인 경제 상황에 관한 이야기를 다루고 있었다. 

  3. 세 번째 토픽은 미국 정부와 트럼프가 홍콩의 시위를 지지하는 내용을 볼 수 있었다. 여기에 한국 학생들이 올린 대자보를 중국인 유학생들이 훼손한 내용이 함께 있었다. 둘 다 홍콩을 지지하는 내용으로 인해 겹치게 나타난 것으로 보인다. 

  4. 네 번째 토픽은 실제 홍콩에서 이뤄지고 있는 집회와 시위로 인한 경찰과 시민들의 충돌에 대해서 다루고 있었다. 실탄 발사에 대한 언급도 볼 수 있었다.

- 전반적으로 토픽을 4개로 나누었을 때, ‘홍콩 시위’가 ‘정치’, ‘경제’, ‘지지’, ‘시위’로 나뉘는 것을 확인할 수 있었다.

#### LDAvis를 이용한 키워드 가중치 분석

앞서 실시한 토픽모델링을 LDAviz를 이용해 가시화해보았다. 
4개의 주제가 모두 서로 떨어져 있었다. 이는 각 주제가 서로 겹치지 않는다는 것을 의미한다.

1. 실제 시위상황과 피해
![image](https://user-images.githubusercontent.com/59859965/161910726-fe18bc27-dd05-4667-81c3-25b8a277dd1a.png)

- 아무래도 키워드가 ‘홍콩 시위’이다 보니 홍콩, 경찰, 시위, 시위대, 집회, 진압, 실탄, 시민들과 같이 실제 시위와 관련된 키워드가 가장 비중을 많이 차지한 것을 확인할 수 있었다.

2. 미국의 대처와 국내 이슈
![image](https://user-images.githubusercontent.com/59859965/161911914-558a47ba-f2d5-440f-b74c-938e16063ea6.png)

- 두번째로 비중을 많이 차지한 내용은 트럼프의 홍콩 지지와 한국인 대학생들이 올린 대자보를 훼손한 중국 유학생에 관한 내용이 비중을 많이 차지했다. (사람들이 관심을 가지기 쉬운 내용이라 기사화가 많이 되었기 때문에 비중을 많이 차지했다고 생각된다.) 

3. 송환법과 캐리 람 행정장관
![image](https://user-images.githubusercontent.com/59859965/161911932-2e26fd75-5a43-48d3-8999-58134ab4950c.png)

4. 미국과 중국의 경제 상황
![image](https://user-images.githubusercontent.com/59859965/161911947-163f92a5-751f-4e1b-b09f-57b6dd257b94.png)

- 송환법과 캐리 람 행정장관에 관한 내용과 홍콩, 중국, 미국의 경제 상황에 관한 내용은 서로 비슷한 비중을 차지고 하고 있었다. 

- 하지만 여기서 확인할 수 있었던 것은 송환법과 캐리 람 행정장관에 관한 내용에서 홍콩과 중국의 키워드가 트럼프의 홍콩 지지와 대자보 훼손 사건보다 더 높은 비율을 보이는 것을 통해, 실질적인 ‘홍콩 시위’에 관련된 내용에 있어서 더욱 비중 있는 내용을 다루고 있다고 판단할 수 있었다.

#### 더욱 세분화 된 주제파악
이전에 주제를 4개로 나눴을 때, 트럼프의 홍콩 지지와 대자보 사건이 겹쳐서 나오는 게 조금 아쉬워서 추가적인 토픽모델링을 진행해보았다. 

![image](https://user-images.githubusercontent.com/59859965/161915679-e1f10c65-23d7-499b-a124-2426997539a2.png)

- 토픽을 5개로 나눴을 때, 두 번째 주제에서 찾으려고 했던 ‘대자보’ 키워드를 볼 수 있었다. 문제는 해당 토픽이 경제 토픽과 합쳐진 것을 확인할 수 있었다.

![image](https://user-images.githubusercontent.com/59859965/161915787-a4cd0e7d-6f5c-47db-b465-f11197144801.png)

- 6개로 나눴을 때, 원래 알고 싶었던 주제들로 좀 더 자세하게 나뉘는 것을 확인할 수 있었다. 
1. 토픽1: 송환법 철회와 캐리 행정장관
2. 토픽2: 중국인 유학생의 대자보 훼손
3. 토픽3: 트럼프 대통령의 법안 지지
4. 토픽4: 구의원 선거와 과잉진압 현장
5. 토픽5: 공산당인 시진핑 주석의 일국양제
6. 토픽6: 홍콩, 중국, 미국의 경제 하락 

#### UCI NET을 이용한 네트워크 분석

네트워크 분석을 위해 UCI NET 소프트웨어를 이용해 홍콩시위에 관련된 키워드의 연관성을 분석하였다.

![image](https://user-images.githubusercontent.com/59859965/161916488-8d534479-c475-41fb-931b-af1c95a6ecc5.png)

- UCINET의 Analysis -> Subgroups -> Girvan-Newman을 이용해서 Link가 0인, 키워드 간 연관성이 전혀 없는 키워드들을 없애주었다.

- 그룹은 총 8개의 그룹으로 나눠서 분석을 시행해 보았다.

#### 네트워크 개별집단 분석

1. 그룹1: 경찰과 시민의 충돌
![image](https://user-images.githubusercontent.com/59859965/161917160-d629a3a0-bf73-4498-b866-8a30546aaa79.png)
![image](https://user-images.githubusercontent.com/59859965/161917451-3f5ab2eb-457d-4ee6-a32e-2b63ff6f9ea8.png)


2. 그룹2: 중국인 유학생의 대자보 훼손

![image](https://user-images.githubusercontent.com/59859965/161917524-ab926dc3-59a4-4b5b-ab40-b38f107567b6.png)
![image](https://user-images.githubusercontent.com/59859965/161917606-29353a8a-12cf-4393-bd11-93b865ce67ac.png)


3. 그룹3: 증시 하락과 미중 무역협상

![image](https://user-images.githubusercontent.com/59859965/161919285-0f5f4b53-9ac9-4e1c-bbb3-602edea326ef.png)
![image](https://user-images.githubusercontent.com/59859965/161919328-127550f4-e440-4899-92df-1bccb21107e9.png)
![image](https://user-images.githubusercontent.com/59859965/161919356-54481a22-6dce-40dd-8795-0d9473425faf.png)

4. 그룹4: 법안으로 통과 된 송환법 반대

![image](https://user-images.githubusercontent.com/59859965/161919172-e4967b5c-2bfa-433c-8ab5-55c3fbb22d77.png)
![image](https://user-images.githubusercontent.com/59859965/161919226-f4ed12fe-4207-4128-a852-b7811e68ad5a.png)


5. 그룹5: 행정장관 직선제 요구, 송환법 철회, 독립수사

![image](https://user-images.githubusercontent.com/59859965/161919491-e64f2ff6-7ab3-4865-adea-f9c6737a34e9.png)
![image](https://user-images.githubusercontent.com/59859965/161919529-5292dae7-1503-4e8d-a196-86b5068bc1c6.png)


6. 그룹6: 구의원 선거에서 이긴 범민주 진영
![image](https://user-images.githubusercontent.com/59859965/161919575-ac4a833e-7e46-4744-80b3-380cf48ce498.png)
![image](https://user-images.githubusercontent.com/59859965/161919608-0e9536ec-0a16-4f19-adea-68944aafed1c.png)


7. 그룹7: 시진핑 국가주석의 일국양제
![image](https://user-images.githubusercontent.com/59859965/161919668-2f5904c1-4c61-4577-bbcc-21e0c6311913.png)
![image](https://user-images.githubusercontent.com/59859965/161919701-69dd1592-1e0a-4825-bd68-f37982691eff.png)

8. 그룹8: 복면금지법 시행

![image](https://user-images.githubusercontent.com/59859965/161918828-03c5b7e5-c675-47b3-9b2c-6588217612c4.png)
![image](https://user-images.githubusercontent.com/59859965/161918885-719e3752-76fc-44f6-aa63-83c7ce51e84b.png)



#### 네트워크 간의 연관성 분석

1. 그룹1 & 그룹2: 경찰의 개입
![image](https://user-images.githubusercontent.com/59859965/161917999-c7d23fe3-e772-4f52-a384-d7256e47b56c.png)


2. 그룹4 & 그룹5 & 그룹6: 홍콩시위의 내부적 요인
![image](https://user-images.githubusercontent.com/59859965/161917943-861eff52-28b5-4a2c-9ddf-9f7988050d39.png)

## III. 결론

#### 토픽모델링 분석결과

- ‘홍콩 시위’를 4가지 주제로 나눴을 때 크게 ‘정치’, ‘경제’, ‘지지’, ‘시위’로 나눌 수 있었다.

- LDAvis에서 확인할 수 있었던 것은 실제 경찰과 시민들 사이의 폭력 시위와 관련된 내용이 가장 큰 비중을 차지하고 있다는 점이었다. 그리고 한국에서 일어난 중국유학생의 대자보 훼손 사건이 전체적인 기사의 비중을 많이 차지하고 있었지만, 실제로 중국, 홍콩과 같은 키워드의 비율이 높은 송환법 철회와 캐리 행정장관과 관련된 내용이 더욱 중요한 비중을 가지고 있다는 것을 알 수 있었다.

- ‘홍콩 시위’를 5가지 주제로 나눴을 때는 주제가 다소 불확실해지는 모습을 보였다.

- ‘홍콩 시위’를 6가지 주제로 나눴을 때 여러 가지 중점적인 주제를 볼 수 있었다.

![image](https://user-images.githubusercontent.com/59859965/161918552-9a77518c-4f86-4c0d-8f40-52449babf803.png)

#### 네트워크 분석 결과

- 총 8개의 집단으로 나눌 수 있었다.

- 각 집단은 하나의 주제를 내포하고 있었다.
![image](https://user-images.githubusercontent.com/59859965/161918670-b88d0e5a-d568-4f9a-9f60-06e5eb0f05fc.png)


- 네트워크 간의 연관성 분석을 통해 국내외 사건의 연관성과 홍콩시위의 내부적 요인을 분석할 수 있었다.
![image](https://user-images.githubusercontent.com/59859965/161918727-e2004b79-8d57-45fb-ab6e-1d42202b37f4.png)





