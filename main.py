def bfs(capacity_matrix, residual_graph, s, t, level):
    for i in range(len(capacity_matrix)):
        level[i] = -1
    level[s] = 0
    q = [s]
    while q:
        u = q.pop(0)
        for v in range(len(capacity_matrix[u])):
            if level[v] < 0 and residual_graph[u][v] > 0:
                level[v] = level[u] + 1
                q.append(v)
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


def dinic(adj_matrix, source, sink):
    n = len(adj_matrix)
    residual_graph = [[adj_matrix[i][j] for j in range(n)] for i in range(n)]

    # Initialize flow to 0
    flow = 0
    level = [-1] * n

    while bfs(adj_matrix, residual_graph, source, sink, level):
        nodes_by_level = [[]] * n
        for i in range(n):
            nodes_by_level[level[i]].append(i)
        while True:
            path = dfs(residual_graph, source, sink, level, nodes_by_level)

            if path is None:
                break
            # Find bottleneck capacity along path
            bottleneck = min(residual_graph[u][v] for u, v in zip(path[:-1], path[1:]))
            # Update flow and residual capacities along path
            for u, v in zip(path[:-1], path[1:]):
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
