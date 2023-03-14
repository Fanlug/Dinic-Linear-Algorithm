def bfs(graph, residual_graph, s, t, level, nodes_by_level):
    for i in range(len(graph)):
        level[i] = -1
    level[s] = 0
    q = [s]
    while q:
        u = q.pop(0)
        for v in range(len(graph)):
            if level[v] < 0 and residual_graph[u][v] > 0:
                level[v] = level[u] + 1
                q.append(v)
    for i in range(len(graph)):
        nodes_by_level[level[i]].append(i)
    return False if level[t] < 0 else True


def dfs(residual_graph, source, sink, level, nodes_by_level):
    stack = [(source, [source])]
    while stack:
        u, path = stack.pop()
        for v in nodes_by_level[level[u] + 1]:
            if level[v] == level[u] + 1 and residual_graph[u][v] > 0:
                if v == sink:
                    path.append(v)
                    return path
                stack.append((v, path + [v]))


def dinic(graph, source, sink):
    n = len(graph)
    residual_graph = [[graph[i][j] for j in range(n)] for i in range(n)]
    flow = 0
    level = [-1] * n
    nodes_by_level = [[] for _ in range(n)]
    while bfs(graph, residual_graph, source, sink, level, nodes_by_level):
        while True:
            path = dfs(residual_graph, source, sink, level, nodes_by_level)

            if path is None:
                break
            # Find bottleneck capacity along path
            bottleneck = float('inf')
            for i in range(len(path) - 1):
                u, v = path[i], path[i + 1]
                bottleneck = min(bottleneck, residual_graph[u][v])
            # Update flow and residual capacities along path
            for i in range(len(path) - 1):
                u, v = path[i], path[i + 1]
                residual_graph[u][v] -= bottleneck
                residual_graph[v][u] += bottleneck
            # Add bottleneck capacity to flow
            flow += bottleneck
    return flow


if __name__ == "__main__":
    C = [[0, 3, 3, 0, 0, 0],  # s
         [0, 0, 2, 3, 0, 0],  # o
         [0, 0, 0, 0, 2, 0],  # p
         [0, 0, 0, 0, 4, 2],  # q
         [0, 0, 0, 0, 0, 2],  # r
         [0, 0, 0, 0, 0, 3]]  # t

    source = 0  # A
    sink = 5  # F
    print("Dinic's Algorithm")
    max_flow_value = dinic(C, source, sink)
    print("max_flow_value is", max_flow_value)
